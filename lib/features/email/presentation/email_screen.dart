import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';

class EmailScreen extends ConsumerStatefulWidget {
  const EmailScreen({super.key});

  @override
  ConsumerState<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends ConsumerState<EmailScreen> {
  final _contextCtrl = TextEditingController();
  String _mode = 'New Email';
  String _tone = 'Polite';
  bool _includeAbSubjects = true;
  String _output = '';
  bool _isStreaming = false;
  String? _error;
  bool _isConfigError = false;

  @override
  void dispose() {
    _contextCtrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final text = _contextCtrl.text.trim();
    if (text.isEmpty || _isStreaming) return;

    final prompt =
        'Draft a $_tone $_mode.${_includeAbSubjects ? " Provide A/B subject line options." : ""}\n\nContext:\n$text';
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
                tool: 'email',
                prompt: prompt,
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
    final estimated =
        AiGatewayClient.estimateCredits(prompt: _contextCtrl.text);

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.navEmail,
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
                Wrap(
                  spacing: MozhiTokens.space12,
                  children: [
                    DropdownButton<String>(
                      value: _mode,
                      items: const [
                        'New Email',
                        'Reply to Thread',
                        'Follow-up',
                        'Cold Outreach'
                      ]
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _mode = v!),
                    ),
                    DropdownButton<String>(
                      value: _tone,
                      items: const ['Polite', 'Direct', 'Warm', 'Executive']
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _tone = v!),
                    ),
                    FilterChip(
                      label: Text(l10n.emailAbSubjects),
                      selected: _includeAbSubjects,
                      onSelected: (v) => setState(() => _includeAbSubjects = v),
                    ),
                  ],
                ),
                const SizedBox(height: MozhiTokens.space12),
                TextField(
                  controller: _contextCtrl,
                  minLines: 3,
                  maxLines: 6,
                  onChanged: (_) => setState(() {}),
                  decoration:
                      InputDecoration(labelText: l10n.emailContextLabel),
                ),
                const SizedBox(height: MozhiTokens.space16),
                FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: MozhiTokens.saffron),
                  onPressed: _isStreaming ? null : _generate,
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
