import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';

class TranslatorScreen extends ConsumerStatefulWidget {
  const TranslatorScreen({super.key});

  @override
  ConsumerState<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends ConsumerState<TranslatorScreen> {
  final _sourceCtrl = TextEditingController();
  String _targetLang = 'Hindi (हिन्दी)';
  String _formality = 'Natural';
  String _output = '';
  bool _isStreaming = false;
  String? _error;
  bool _isConfigError = false;

  static const _languages = [
    'Hindi (हिन्दी)',
    'Urdu (اردو)',
    'Tamil (தமிழ்)',
    'Telugu (తెలుగు)',
    'Bengali (বাংলা)',
    'Marathi (मराठी)',
    'Kannada (ಕನ್ನಡ)',
    'Malayalam (മലയാളം)',
    'Gujarati (ગુજરાતી)',
    'Punjabi (ਪੰਜਾਬੀ)',
    'English',
    'Spanish',
    'French',
    'Arabic',
    'German',
  ];

  @override
  void dispose() {
    _sourceCtrl.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    final text = _sourceCtrl.text.trim();
    if (text.isEmpty || _isStreaming) return;

    final prompt =
        'Translate the following text into $_targetLang with a $_formality tone, preserving paragraph alignment and handling code-mixed/Hinglish input natively:\n\n$text';
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
                tool: 'translator',
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
    final estimated = AiGatewayClient.estimateCredits(prompt: _sourceCtrl.text);

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.navTranslator,
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
                      value: _targetLang,
                      items: _languages
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _targetLang = v!),
                    ),
                    DropdownButton<String>(
                      value: _formality,
                      items: const ['Natural', 'Formal', 'Casual']
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _formality = v!),
                    ),
                  ],
                ),
                const SizedBox(height: MozhiTokens.space12),
                TextField(
                  controller: _sourceCtrl,
                  minLines: 3,
                  maxLines: 6,
                  onChanged: (_) => setState(() {}),
                  decoration:
                      InputDecoration(labelText: l10n.translatorSourceLabel),
                ),
                const SizedBox(height: MozhiTokens.space16),
                FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: MozhiTokens.saffron),
                  onPressed: _isStreaming ? null : _translate,
                  child: Text(l10n.actionTranslate),
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
