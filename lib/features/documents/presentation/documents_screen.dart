import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';

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

  static const _allowedExtensions = ['pdf', 'txt', 'png', 'jpg', 'jpeg', 'webp'];
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
    if (file.size > _maxFreeBytes) {
      setState(() {
        _error = 'File too large for Free plan (max 5 MB).';
      });
      return;
    }
    final ext = file.extension?.toLowerCase();
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

  Future<void> _summarize() async {
    final text = _textCtrl.text.trim();
    if ((text.isEmpty && _fileBytes == null) || _isStreaming) return;

    final prompt = text.isNotEmpty
        ? 'Produce a $_summaryMode of the following untrusted document text. Keep clear structure.\n\n[DOCUMENT START]\n$text\n[DOCUMENT END]'
        : 'Read the attached document/image ($_fileName) and produce a clear $_summaryMode.';
    final estimated = AiGatewayClient.estimateCredits(prompt: prompt);
    if (!await confirmCreditCostIfNeeded(context, estimatedCredits: estimated) ||
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
      await for (final token in ref.read(aiGatewayClientProvider).streamCompletion(
            tool: 'summarizer',
            prompt: prompt,
            fileBytes: _fileBytes,
            fileMimeType: _fileMimeType,
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
    final theme = Theme.of(context);
    final estimated = AiGatewayClient.estimateCredits(prompt: _textCtrl.text);

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.navDocs,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            CreditCostPill(credits: estimated),
          ],
        ),
        const SizedBox(height: MozhiTokens.space16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(MozhiTokens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file_outlined),
                  label: Text(_fileName == null
                      ? l10n.docsPickFile
                      : '$_fileName (${((_fileSizeBytes ?? 0) / 1024).toStringAsFixed(1)} KB)'),
                ),
                const SizedBox(height: MozhiTokens.space12),
                DropdownButton<String>(
                  value: _summaryMode,
                  isExpanded: true,
                  items: const [
                    'Short Summary',
                    'Detailed Summary',
                    'Bullet Points',
                    'Chapter-wise Summary',
                    'Q&A Pairs',
                    'Flashcards',
                    'Mind-map Outline',
                  ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
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
                  style: FilledButton.styleFrom(backgroundColor: MozhiTokens.saffron),
                  onPressed: _isStreaming ? null : _summarize,
                  child: Text(l10n.actionGenerate),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: MozhiTokens.space16),
        AiOutputCard(
          output: _output,
          isStreaming: _isStreaming,
          errorMessage: _error,
          isConfigError: _isConfigError,
        ),
      ],
    );
  }
}
