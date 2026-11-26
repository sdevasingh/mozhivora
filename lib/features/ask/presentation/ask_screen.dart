import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';
import 'package:mozhivora/shared/widgets/mozhi_empty_state.dart';

class _ChatTurn {
  _ChatTurn({required this.role, required this.text});
  final String role;
  String text;
}

class AskScreen extends ConsumerStatefulWidget {
  const AskScreen({super.key, this.initialPrompt});

  final String? initialPrompt;

  @override
  ConsumerState<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends ConsumerState<AskScreen> {
  final _promptCtrl = TextEditingController();
  final List<_ChatTurn> _turns = [];
  bool _isStreaming = false;
  bool _highQuality = false;
  String? _error;
  bool _isConfigError = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      _promptCtrl.text = widget.initialPrompt!;
    }
  }

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  Future<void> _send([String? overridePrompt]) async {
    final prompt = (overridePrompt ?? _promptCtrl.text).trim();
    if (prompt.isEmpty || _isStreaming) return;

    final estimated = AiGatewayClient.estimateCredits(
      prompt: prompt,
      highQuality: _highQuality,
    );
    final ok = await confirmCreditCostIfNeeded(
      context,
      estimatedCredits: estimated,
    );
    if (!ok || !mounted) return;

    setState(() {
      if (overridePrompt == null) _promptCtrl.clear();
      _turns.add(_ChatTurn(role: 'user', text: prompt));
      _turns.add(_ChatTurn(role: 'assistant', text: ''));
      _isStreaming = true;
      _error = null;
      _isConfigError = false;
    });

    try {
      final stream = ref.read(aiGatewayClientProvider).streamCompletion(
            tool: 'ask',
            prompt: prompt,
            highQuality: _highQuality,
          );
      await for (final token in stream) {
        if (!mounted) return;
        setState(() {
          _turns.last.text += token;
        });
      }
    } on AiGatewayException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isConfigError = e.isConfigError;
        if (_turns.isNotEmpty && _turns.last.text.isEmpty) {
          _turns.removeLast();
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isStreaming = false);
      }
    }
  }

  void _branchChat() {
    if (_turns.length <= 2) return;
    setState(() {
      _turns.removeRange(0, _turns.length - 2);
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final estimated = AiGatewayClient.estimateCredits(
      prompt: _promptCtrl.text,
      highQuality: _highQuality,
    );

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(MozhiTokens.space24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.navAsk,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Row(
                    children: [
                      if (_turns.length > 2)
                        IconButton(
                          tooltip: l10n.askBranchChat,
                          icon: const Icon(Icons.call_split_outlined),
                          onPressed: _branchChat,
                        ),
                      FilterChip(
                        label: Text(l10n.aiDepthMode),
                        selected: _highQuality,
                        onSelected: (v) => setState(() => _highQuality = v),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: MozhiTokens.space16),
              if (_turns.isEmpty && _error == null)
                MozhiEmptyState(
                  icon: Icons.auto_awesome_outlined,
                  title: l10n.emptyWorkspaceTitle,
                  subtitle: l10n.askSubtitle,
                  samplePrompts: const [
                    'Explain photosynthesis simply in Hindi and English',
                    'Break down my weekly goals into 3 daily tasks',
                  ],
                  onPromptTap: (p) => _promptCtrl.text = p,
                )
              else
                ..._turns.map((t) {
                  final isUser = t.role == 'user';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: MozhiTokens.space12),
                    child: isUser
                        ? Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Container(
                              padding:
                                  const EdgeInsets.all(MozhiTokens.space12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(
                                    MozhiTokens.radiusCard),
                              ),
                              child: SelectableText(t.text),
                            ),
                          )
                        : AiOutputCard(
                            output: t.text,
                            isStreaming: _isStreaming && t == _turns.last,
                          ),
                  );
                }),
              if (_error != null)
                AiOutputCard(
                  output: '',
                  isStreaming: false,
                  errorMessage: _error,
                  isConfigError: _isConfigError,
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(MozhiTokens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promptCtrl,
                      minLines: 1,
                      maxLines: 4,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: l10n.commandBarHint,
                      ),
                    ),
                  ),
                  const SizedBox(width: MozhiTokens.space12),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: MozhiTokens.saffron,
                    ),
                    onPressed: _isStreaming ? null : () => _send(),
                    icon: const Icon(Icons.send),
                    label: Text(l10n.actionSend),
                  ),
                ],
              ),
              const SizedBox(height: MozhiTokens.space8),
              CreditCostPill(credits: estimated),
            ],
          ),
        ),
      ],
    );
  }
}
