import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/atelier_frame.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';
import 'package:mozhivora/shared/widgets/mozhi_dropdown.dart';
import 'package:mozhivora/shared/widgets/mozhi_status_banner.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final _textCtrl = TextEditingController();
  String? _fileName;
  int? _fileSizeBytes;
  Uint8List? _fileBytes;
  String? _fileMimeType;
  String _summaryMode = 'Short Summary';
  String _output = '';
  bool _isStreaming = false;
  String? _error;
  bool _isConfigError = false;

  static const _allowedExtensions = [
    'pdf',
    'docx',
    'txt',
    'pptx',
    'png',
    'jpg',
    'jpeg',
    'webp',
  ];
  static const _maxFreeBytes = 5 * 1024 * 1024;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  String? _mimeForExtension(String? ext) => switch (ext?.toLowerCase()) {
        'pdf' => 'application/pdf',
        'png' => 'image/png',
        'jpg' || 'jpeg' => 'image/jpeg',
        'webp' => 'image/webp',
        _ => null,
      };

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.size <= 0 || file.bytes == null || file.bytes!.isEmpty) {
      setState(() {
        _error = 'Selected file is empty or unreadable.';
      });
      return;
    }
    if (file.size > _maxFreeBytes) {
      setState(() {
        _error = 'File too large for Free plan (max 5 MB).';
      });
      return;
    }
    final ext = file.extension?.toLowerCase();
    if (ext == 'docx' || ext == 'pptx') {
      setState(() {
        _error =
            '${ext!.toUpperCase()} binary parsing requires server extraction; upload a PDF/image or paste the text below.';
      });
      return;
    }
    setState(() {
      _fileName = file.name;
      _fileSizeBytes = file.size;
      _error = null;
      if (ext == 'txt' && file.bytes != null) {
        _textCtrl.text = String.fromCharCodes(file.bytes!);
        _fileBytes = null;
        _fileMimeType = null;
      } else {
        _fileBytes = file.bytes;
        _fileMimeType = _mimeForExtension(ext);
      }
    });
  }

  void _clearFile() {
    setState(() {
      _fileName = null;
      _fileSizeBytes = null;
      _fileBytes = null;
      _fileMimeType = null;
    });
  }

  Future<void> _summarize() async {
    if (_isStreaming) return;
    final text = _textCtrl.text.trim();
    if (text.isEmpty && _fileBytes == null) {
      setState(() {
        _error = 'Please upload a PDF/image or paste document text first.';
        _isConfigError = false;
      });
      return;
    }

    // Explicit precedence: pasted text wins if both exist, unless user clears text.
    final useText = text.isNotEmpty;
    final prompt = useText
        ? 'Produce a $_summaryMode of the following untrusted document text. Keep clear structure.\n\n[DOCUMENT START]\n$text\n[DOCUMENT END]'
        : 'Read the attached document/image ($_fileName) and produce a clear $_summaryMode.';
    final estimated = AiGatewayClient.estimateCredits(prompt: prompt);
    if (!await confirmCreditCostIfNeeded(context,
            estimatedCredits: estimated) ||
        !mounted) {
      return;
    }

    setState(() {
      _output = '';
      _isStreaming = true;
      _error = null;
      _isConfigError = false;
    });

    try {
      await for (final token
          in ref.read(aiGatewayClientProvider).streamCompletion(
                tool: 'summarizer',
                prompt: prompt,
                fileBytes: useText ? null : _fileBytes,
                fileMimeType: useText ? null : _fileMimeType,
              )) {
        if (!mounted) return;
        setState(() => _output += token);
      }
    } on AiGatewayException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isConfigError = e.isConfigError;
      });
    } finally {
      if (mounted) setState(() => _isStreaming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final estimated = AiGatewayClient.estimateCredits(prompt: _textCtrl.text);
    final hasBoth = _fileBytes != null && _textCtrl.text.trim().isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        AtelierPageHeader(
          indexTag: '05 // Documents & OCR',
          title: l10n.navDocs,
          trailing: CreditCostPill(credits: estimated),
        ),
        const SizedBox(height: MozhiTokens.space16),
        AtelierBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isStreaming ? null : _pickFile,
                      icon: const Icon(Icons.upload_file_outlined),
                      label: Text(_fileName == null
                          ? l10n.docsPickFile
                          : '$_fileName (${((_fileSizeBytes ?? 0) / 1024).toStringAsFixed(1)} KB)'),
                    ),
                  ),
                  if (_fileName != null) ...[
                    const SizedBox(width: MozhiTokens.space8),
                    IconButton(
                      tooltip: 'Remove file',
                      onPressed: _isStreaming ? null : _clearFile,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ],
              ),
              if (hasBoth) ...[
                const SizedBox(height: MozhiTokens.space12),
                const MozhiStatusBanner(
                  kind: MozhiBannerKind.info,
                  message:
                      'Both a file and pasted text are present. Pasted text will be used; clear text below to summarize the attached file.',
                ),
              ],
              const SizedBox(height: MozhiTokens.space12),
              MozhiDropdown<String>(
                label: 'Summary mode',
                value: _summaryMode,
                enabled: !_isStreaming,
                items: const [
                  'Short Summary',
                  'Detailed Summary',
                  'Bullet Points',
                  'Chapter-wise Summary',
                  'Q&A Pairs',
                  'Flashcards',
                  'Mind-map Outline',
                ]
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => _summaryMode = v!),
              ),
              const SizedBox(height: MozhiTokens.space12),
              TextField(
                controller: _textCtrl,
                minLines: 4,
                maxLines: 8,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: l10n.docsPasteHint),
              ),
              const SizedBox(height: MozhiTokens.space16),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: MozhiTokens.saffron,
                  foregroundColor: MozhiTokens.charcoal,
                ),
                onPressed: _isStreaming ? null : _summarize,
                child: Text(
                  _isStreaming ? l10n.aiStreamingLabel : l10n.actionGenerate,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: MozhiTokens.space16),
        AiOutputCard(
          output: _output,
          isStreaming: _isStreaming,
          errorMessage: _error,
          isConfigError: _isConfigError,
          onRetry: _summarize,
        ),
      ],
    );
  }
}
