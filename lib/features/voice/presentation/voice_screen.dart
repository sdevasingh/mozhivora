import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/features/task_planner/data/task_provider.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';

class VoiceScreen extends ConsumerStatefulWidget {
  const VoiceScreen({super.key});

  @override
  ConsumerState<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends ConsumerState<VoiceScreen> {
  final _transcriptCtrl = TextEditingController();
  bool _speakerLabels = true;
  String _output = '';
  bool _isStreaming = false;
  String? _error;
  bool _isConfigError = false;

  @override
  void dispose() {
    _transcriptCtrl.dispose();
    super.dispose();
  }

  Future<void> _summarizeMeeting() async {
    final text = _transcriptCtrl.text.trim();
    if (text.isEmpty || _isStreaming) return;

    final prompt =
        'Summarize this meeting transcript${_speakerLabels ? " preserving speaker labels" : ""}. Separate output into: Decisions, Open Questions, and Action Items (one bullet per action).\n\n$text';
    final est = AiGatewayClient.estimateCredits(prompt: prompt);
    if (!await confirmCreditCostIfNeeded(context, estimatedCredits: est) ||
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
      await for (final tok
          in ref.read(aiGatewayClientProvider).streamCompletion(
                tool: 'notes',
                prompt: prompt,
              )) {
        if (!mounted) return;
        setState(() => _output += tok);
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

  Future<void> _convertActionItemsToTasks() async {
    final lines = _output
        .split('\n')
        .where((l) => l.trim().startsWith('-') || l.trim().startsWith('*'))
        .map((l) => l.trim().substring(1).trim())
        .where((l) => l.isNotEmpty)
        .toList();

    for (final line in lines) {
      await ref.read(taskListProvider.notifier).addTask(line);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${lines.length} tasks to Task Planner.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final est = AiGatewayClient.estimateCredits(prompt: _transcriptCtrl.text);

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.navVoice,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            CreditCostPill(credits: est),
          ],
        ),
        const SizedBox(height: MozhiTokens.space16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(MozhiTokens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.voiceSpeakerLabels),
                  value: _speakerLabels,
                  onChanged: (v) => setState(() => _speakerLabels = v),
                ),
                TextField(
                  controller: _transcriptCtrl,
                  minLines: 4,
                  maxLines: 8,
                  onChanged: (_) => setState(() {}),
                  decoration:
                      InputDecoration(labelText: l10n.voiceTranscriptHint),
                ),
                const SizedBox(height: MozhiTokens.space16),
                FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: MozhiTokens.saffron),
                  onPressed: _isStreaming ? null : _summarizeMeeting,
                  child: Text(l10n.actionGenerate),
                ),
              ],
            ),
          ),
        ),
        if (_output.isNotEmpty) ...[
          const SizedBox(height: MozhiTokens.space12),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: _convertActionItemsToTasks,
              icon: const Icon(Icons.playlist_add_check),
              label: Text(l10n.voiceToTasks),
            ),
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
