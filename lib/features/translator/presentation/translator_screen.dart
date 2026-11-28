import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/atelier_frame.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';
import 'package:mozhivora/shared/widgets/mozhi_dropdown.dart';

class TranslatorScreen extends ConsumerStatefulWidget {
  const TranslatorScreen({super.key});

  @override
  ConsumerState<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends ConsumerState<TranslatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sourceCtrl = TextEditingController();
  String _sourceLang = 'Auto-detect (incl. Hinglish)';
  String _targetLang = 'Hindi (हिन्दी)';
  String _formality = 'Natural';
  String _output = '';
  bool _isStreaming = false;
  String? _error;
  bool _isConfigError = false;

  static const _autoDetect = 'Auto-detect (incl. Hinglish)';
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

  void _swapLanguages() {
    if (_sourceLang == _autoDetect) {
      setState(() {
        _sourceLang = _targetLang;
        _targetLang = 'English';
      });
    } else {
      setState(() {
        final prevSource = _sourceLang;
        _sourceLang = _targetLang;
        _targetLang = prevSource;
      });
    }
  }

  bool get _isTargetRtl =>
      _targetLang.startsWith('Urdu') || _targetLang == 'Arabic';

  Future<void> _translate() async {
    if (_isStreaming) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final text = _sourceCtrl.text.trim();
    if (text.isEmpty) return;

    final sourceClause = _sourceLang == _autoDetect
        ? 'auto-detecting the source language (including Hinglish and mixed scripts)'
        : 'from $_sourceLang';
    final prompt =
        'Translate the following text $sourceClause into $_targetLang with a $_formality tone, preserving paragraph alignment:\n\n$text';
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
    final estimated = AiGatewayClient.estimateCredits(prompt: _sourceCtrl.text);

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        AtelierPageHeader(
          indexTag: '04 // Multilingual Translator',
          title: l10n.navTranslator,
          trailing: CreditCostPill(credits: estimated),
        ),
        const SizedBox(height: MozhiTokens.space16),
        AtelierBox(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 560;
                    final sourceDrop = MozhiDropdown<String>(
                      label: 'From',
                      value: _sourceLang,
                      enabled: !_isStreaming,
                      items: [_autoDetect, ..._languages]
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _sourceLang = v!),
                    );
                    final swapBtn = IconButton(
                      tooltip: 'Swap languages',
                      onPressed: _isStreaming ? null : _swapLanguages,
                      icon: const Icon(Icons.swap_horiz),
                    );
                    final targetDrop = MozhiDropdown<String>(
                      label: 'To',
                      value: _targetLang,
                      enabled: !_isStreaming,
                      items: _languages
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _targetLang = v!),
                    );
                    final styleDrop = MozhiDropdown<String>(
                      label: 'Style',
                      value: _formality,
                      enabled: !_isStreaming,
                      items: const ['Natural', 'Formal', 'Casual']
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _formality = v!),
                    );

                    if (isWide) {
                      return Row(
                        children: [
                          Expanded(flex: 3, child: sourceDrop),
                          const SizedBox(width: 4),
                          swapBtn,
                          const SizedBox(width: 4),
                          Expanded(flex: 3, child: targetDrop),
                          const SizedBox(width: MozhiTokens.space12),
                          Expanded(flex: 2, child: styleDrop),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        sourceDrop,
                        Center(child: swapBtn),
                        targetDrop,
                        const SizedBox(height: MozhiTokens.space12),
                        styleDrop,
                      ],
                    );
                  },
                ),
                const SizedBox(height: MozhiTokens.space12),
                TextFormField(
                  controller: _sourceCtrl,
                  minLines: 3,
                  maxLines: 6,
                  onChanged: (_) => setState(() {}),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter text to translate'
                      : null,
                  decoration:
                      InputDecoration(labelText: l10n.translatorSourceLabel),
                ),
                const SizedBox(height: MozhiTokens.space16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: MozhiTokens.saffron,
                    foregroundColor: MozhiTokens.charcoal,
                  ),
                  onPressed: _isStreaming ? null : _translate,
                  child: Text(
                    _isStreaming ? l10n.aiStreamingLabel : l10n.actionTranslate,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
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
          textDirection: _isTargetRtl ? TextDirection.rtl : null,
          onRetry: _translate,
        ),
      ],
    );
  }
}
