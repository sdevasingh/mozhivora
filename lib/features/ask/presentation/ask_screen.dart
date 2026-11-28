import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/atelier_frame.dart';
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
  final _scrollCtrl = ScrollController();
  final List<_ChatTurn> _turns = [];
  StreamSubscription<String>? _streamSub;
  bool _isStreaming = false;
  bool _highQuality = false;
  String? _error;
  bool _isConfigError = false;
  String? _lastPrompt;

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      _promptCtrl.text = widget.initialPrompt!;
    }
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    _promptCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: MozhiTokens.motionHover,
          curve: MozhiTokens.motionCurve,
        );
      }
    });
  }

  Future<void> _send([String? overridePrompt]) async {
    final prompt = (overridePrompt ?? _promptCtrl.text).trim();
    if (_isStreaming) return;
    if (prompt.isEmpty) {
      setState(() {
        _error = 'Please type a question before sending.';
        _isConfigError = false;
      });
      return;
    }

    final estimated = AiGatewayClient.estimateCredits(
      prompt: prompt,
      highQuality: _highQuality,
    );
    final ok = await confirmCreditCostIfNeeded(
      context,
      estimatedCredits: estimated,
    );
    if (!ok || !mounted) return;

    _lastPrompt = prompt;
    setState(() {
      if (overridePrompt == null) _promptCtrl.clear();
      _turns.add(_ChatTurn(role: 'user', text: prompt));
      _turns.add(_ChatTurn(role: 'assistant', text: ''));
      _isStreaming = true;
      _error = null;
      _isConfigError = false;
    });
    _scrollToBottom();

    final stream = ref.read(aiGatewayClientProvider).streamCompletion(
          tool: 'ask',
          prompt: prompt,
          highQuality: _highQuality,
        );

    _streamSub = stream.listen(
      (token) {
        if (!mounted) return;
        setState(() => _turns.last.text += token);
        _scrollToBottom();
      },
      onError: (Object err) {
        if (!mounted) return;
        setState(() {
          _error = err.toString();
          _isConfigError = err is AiGatewayException && err.isConfigError;
          if (_turns.isNotEmpty && _turns.last.text.isEmpty) {
            _turns.removeLast();
          }
          _isStreaming = false;
        });
      },
      onDone: () {
        if (mounted) setState(() => _isStreaming = false);
      },
      cancelOnError: true,
    );
  }

  void _stopStreaming() {
    _streamSub?.cancel();
    setState(() => _isStreaming = false);
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
            controller: _scrollCtrl,
            padding: const EdgeInsets.all(MozhiTokens.space24),
            children: [
              AtelierPageHeader(
                indexTag: '01 // Studio Chat',
                title: l10n.navAsk,
                trailing: Wrap(
                  spacing: MozhiTokens.space8,
                  crossAxisAlignment: WrapCrossAlignment.center,
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
                      onSelected: _isStreaming
                          ? null
                          : (v) => setState(() => _highQuality = v),
                    ),
                    CreditCostPill(credits: estimated),
                  ],
                ),
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
                  onPromptTap: (p) => setState(() => _promptCtrl.text = p),
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
                                    .withValues(alpha: 0.14),
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
                  onRetry:
                      _lastPrompt != null ? () => _send(_lastPrompt) : null,
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(MozhiTokens.space16),
          child: Row(
            children: [
              Expanded(
                child: Focus(
                  onKeyEvent: (_, event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.enter &&
                        !HardwareKeyboard.instance.isShiftPressed) {
                      _send();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: TextField(
                    controller: _promptCtrl,
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: l10n.askSubtitle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: MozhiTokens.space12),
              if (_isStreaming)
                OutlinedButton.icon(
                  onPressed: _stopStreaming,
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text('Stop'),
                )
              else
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: MozhiTokens.saffron,
                    foregroundColor: MozhiTokens.charcoal,
                  ),
                  onPressed: () => _send(),
                  icon: const Icon(Icons.send),
                  label: Text(
                    l10n.actionSend,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
