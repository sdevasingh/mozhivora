import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';

class DocumentCitation {
  const DocumentCitation({
    required this.documentTitle,
    required this.pageNumber,
    required this.excerpt,
  });

  final String documentTitle;
  final int pageNumber;
  final String excerpt;
}

class DocumentChatScreen extends ConsumerStatefulWidget {
  const DocumentChatScreen({super.key});

  @override
  ConsumerState<DocumentChatScreen> createState() => _DocumentChatScreenState();
}

class _DocumentChatScreenState extends ConsumerState<DocumentChatScreen> {
  final _questionCtrl = TextEditingController();
  final _contextCtrl = TextEditingController();
  String _output = '';
  bool _isStreaming = false;
  String? _error;
  bool _isConfigError = false;
  List<DocumentCitation> _citations = [];

  @override
  void dispose() {
    _questionCtrl.dispose();
    _contextCtrl.dispose();
    super.dispose();
  }

  /// Extracts deterministic page-level citations from pasted/indexed passages.
  List<DocumentCitation> _extractGroundedCitations(String source) {
    final clean = source.trim();
    if (clean.isEmpty) return [];
    final pages = clean.split(RegExp(r'\n---+\n'));
    return [
      for (var i = 0; i < pages.length; i++)
        if (pages[i].trim().isNotEmpty)
          DocumentCitation(
            documentTitle: 'Uploaded Document',
            pageNumber: i + 1,
            excerpt: pages[i].trim(),
          ),
    ];
  }

  Future<void> _ask() async {
    final q = _questionCtrl.text.trim();
    if (q.isEmpty || _isStreaming) return;

    final citations = _extractGroundedCitations(_contextCtrl.text);
    if (citations.isEmpty) {
      setState(() {
        _output = 'Not found in document. Add or index a document first.';
        _citations = [];
        _error = null;
      });
      return;
    }

    final groundedPrompt = [
      'Answer the question using ONLY the numbered document passages below.',
      'Cite page numbers like [p.1]. If the answer is not in the passages, reply exactly: "Not found in document."',
      '',
      ...citations.map((c) => '[p.${c.pageNumber}] ${c.excerpt}'),
      '',
      'Question: $q',
    ].join('\n');

    final estimated = AiGatewayClient.estimateCredits(prompt: groundedPrompt);
    if (!await confirmCreditCostIfNeeded(context,
            estimatedCredits: estimated) ||
        !mounted) {
      return;
    }

    setState(() {
      _output = '';
      _citations = citations;
      _isStreaming = true;
      _error = null;
      _isConfigError = false;
    });

    try {
      await for (final token
          in ref.read(aiGatewayClientProvider).streamCompletion(
                tool: 'document_chat',
                prompt: groundedPrompt,
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
    final estimated = AiGatewayClient.estimateCredits(
      prompt: '${_contextCtrl.text}\n${_questionCtrl.text}',
    );

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.navDocumentChat,
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
                TextField(
                  controller: _contextCtrl,
                  minLines: 3,
                  maxLines: 6,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l10n.docChatPassagesLabel,
                    hintText: 'Separate pages with ---',
                  ),
                ),
                const SizedBox(height: MozhiTokens.space12),
                TextField(
                  controller: _questionCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration:
                      InputDecoration(labelText: l10n.docChatQuestionLabel),
                ),
                const SizedBox(height: MozhiTokens.space16),
                FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: MozhiTokens.saffron),
                  onPressed: _isStreaming ? null : _ask,
                  child: Text(l10n.actionSend),
                ),
              ],
            ),
          ),
        ),
        if (_citations.isNotEmpty) ...[
          const SizedBox(height: MozhiTokens.space12),
          Wrap(
            spacing: MozhiTokens.space8,
            children: _citations
                .map(
                  (c) => ActionChip(
                    avatar: const Icon(Icons.menu_book_outlined, size: 16),
                    label: Text('${c.documentTitle} · p.${c.pageNumber}'),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title:
                              Text('${c.documentTitle} — Page ${c.pageNumber}'),
                          content:
                              SingleChildScrollView(child: Text(c.excerpt)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ],
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
