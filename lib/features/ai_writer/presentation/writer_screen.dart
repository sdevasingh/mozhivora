import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/features/ai_writer/data/brand_voice_provider.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/atelier_frame.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';
import 'package:mozhivora/shared/widgets/mozhi_dropdown.dart';

class WriterScreen extends ConsumerStatefulWidget {
  const WriterScreen({super.key, this.initialTopic});

  final String? initialTopic;

  @override
  ConsumerState<WriterScreen> createState() => _WriterScreenState();
}

class _WriterScreenState extends ConsumerState<WriterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topicCtrl = TextEditingController();
  String _docType = 'Article';
  String _tone = 'Clear & warm';
  String _length = 'Medium';
  String? _selectedBrandVoiceId;
  String _output = '';
  bool _isStreaming = false;
  String? _error;
  bool _isConfigError = false;
  String? _lastAction;

  @override
  void initState() {
    super.initState();
    if (widget.initialTopic != null && widget.initialTopic!.isNotEmpty) {
      _topicCtrl.text = widget.initialTopic!;
    }
  }

  @override
  void dispose() {
    _topicCtrl.dispose();
    super.dispose();
  }

  Future<void> _showCreateBrandVoiceDialog() async {
    final dialogFormKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final toneCtrl = TextEditingController();
    final sample1Ctrl = TextEditingController();
    final sample2Ctrl = TextEditingController();
    final sample3Ctrl = TextEditingController();

    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Brand Voice Kit'),
        content: SingleChildScrollView(
          child: Form(
            key: dialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Kit name is required'
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Kit name (e.g. Newsletter)',
                  ),
                ),
                const SizedBox(height: MozhiTokens.space8),
                TextFormField(
                  controller: toneCtrl,
                  decoration: const InputDecoration(labelText: 'Tone summary'),
                ),
                const SizedBox(height: MozhiTokens.space8),
                TextFormField(
                  controller: sample1Ctrl,
                  decoration:
                      const InputDecoration(labelText: 'Writing sample 1'),
                ),
                const SizedBox(height: MozhiTokens.space8),
                TextFormField(
                  controller: sample2Ctrl,
                  decoration:
                      const InputDecoration(labelText: 'Writing sample 2'),
                ),
                const SizedBox(height: MozhiTokens.space8),
                TextFormField(
                  controller: sample3Ctrl,
                  decoration:
                      const InputDecoration(labelText: 'Writing sample 3'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (dialogFormKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop(true);
              }
            },
            child: const Text('Save Kit'),
          ),
        ],
      ),
    );

    final name = nameCtrl.text;
    final tone = toneCtrl.text;
    final samples = [sample1Ctrl.text, sample2Ctrl.text, sample3Ctrl.text];
    nameCtrl.dispose();
    toneCtrl.dispose();
    sample1Ctrl.dispose();
    sample2Ctrl.dispose();
    sample3Ctrl.dispose();

    if (created == true && name.trim().isNotEmpty) {
      await ref.read(brandVoiceProvider.notifier).addKit(
            name: name,
            toneSummary: tone,
            samples: samples,
          );
    }
  }

  Future<void> _generate([String? inlineAction]) async {
    if (_isStreaming) return;
    if (inlineAction == null && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final baseTopic = _topicCtrl.text.trim();
    if (baseTopic.isEmpty && inlineAction == null) return;

    _lastAction = inlineAction;
    final kits = ref.read(brandVoiceProvider);
    final activeKit =
        kits.where((k) => k.id == _selectedBrandVoiceId).firstOrNull;
    final voiceGuide = activeKit != null
        ? '\nMatch Brand Voice "${activeKit.name}" (${activeKit.toneSummary}). Samples: ${activeKit.samples.join(" | ")}'
        : '';

    final prompt = inlineAction != null && _output.isNotEmpty
        ? '$inlineAction the following draft, keeping the $_tone tone:$voiceGuide\n\n$_output'
        : 'Write a $_length $_docType in a $_tone tone about: $baseTopic$voiceGuide';

    final estimated = AiGatewayClient.estimateCredits(prompt: prompt);
    final ok = await confirmCreditCostIfNeeded(
      context,
      estimatedCredits: estimated,
    );
    if (!ok || !mounted) return;

    setState(() {
      _output = '';
      _isStreaming = true;
      _error = null;
      _isConfigError = false;
    });

    try {
      await for (final token
          in ref.read(aiGatewayClientProvider).streamCompletion(
                tool: 'writer',
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
    final kits = ref.watch(brandVoiceProvider);
    final estimated = AiGatewayClient.estimateCredits(prompt: _topicCtrl.text);

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        AtelierPageHeader(
          indexTag: '02 // Studio Writer',
          title: l10n.navWriter,
          trailing: CreditCostPill(credits: estimated),
        ),
        const SizedBox(height: MozhiTokens.space16),
        AtelierBox(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _topicCtrl,
                  minLines: 2,
                  maxLines: 4,
                  onChanged: (_) => setState(() {}),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter a topic or draft prompt'
                      : null,
                  decoration: InputDecoration(labelText: l10n.writerTopicLabel),
                ),
                const SizedBox(height: MozhiTokens.space12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = constraints.maxWidth >= 600
                        ? (constraints.maxWidth - 36) / 4
                        : (constraints.maxWidth - 12) / 2;
                    return Wrap(
                      spacing: MozhiTokens.space12,
                      runSpacing: MozhiTokens.space12,
                      children: [
                        SizedBox(
                          width: itemWidth,
                          child: MozhiDropdown<String>(
                            label: 'Type',
                            value: _docType,
                            enabled: !_isStreaming,
                            items: const [
                              'Article',
                              'Blog Post',
                              'Social Post',
                              'Proposal'
                            ]
                                .map((v) =>
                                    DropdownMenuItem(value: v, child: Text(v)))
                                .toList(),
                            onChanged: (v) => setState(() => _docType = v!),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: MozhiDropdown<String>(
                            label: 'Tone',
                            value: _tone,
                            enabled: !_isStreaming,
                            items: const [
                              'Clear & warm',
                              'Formal',
                              'Friendly',
                              'Persuasive'
                            ]
                                .map((v) =>
                                    DropdownMenuItem(value: v, child: Text(v)))
                                .toList(),
                            onChanged: (v) => setState(() => _tone = v!),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: MozhiDropdown<String>(
                            label: 'Length',
                            value: _length,
                            enabled: !_isStreaming,
                            items: const ['Short', 'Medium', 'Detailed']
                                .map((v) =>
                                    DropdownMenuItem(value: v, child: Text(v)))
                                .toList(),
                            onChanged: (v) => setState(() => _length = v!),
                          ),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: MozhiDropdown<String?>(
                            label: 'Voice',
                            value: _selectedBrandVoiceId,
                            enabled: !_isStreaming,
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('Default Voice'),
                              ),
                              ...kits.map(
                                (k) => DropdownMenuItem<String?>(
                                  value: k.id,
                                  child: Text(k.name),
                                ),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => _selectedBrandVoiceId = v),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: MozhiTokens.space8),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed:
                        _isStreaming ? null : _showCreateBrandVoiceDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Brand Voice'),
                  ),
                ),
                const SizedBox(height: MozhiTokens.space12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: MozhiTokens.saffron,
                    foregroundColor: MozhiTokens.charcoal,
                  ),
                  onPressed: _isStreaming ? null : () => _generate(),
                  child: Text(
                    _isStreaming ? l10n.aiStreamingLabel : l10n.actionGenerate,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_output.isNotEmpty) ...[
          const SizedBox(height: MozhiTokens.space12),
          Wrap(
            spacing: MozhiTokens.space8,
            runSpacing: MozhiTokens.space8,
            children: ['Rewrite', 'Shorten', 'Expand', 'Fix grammar']
                .map(
                  (act) => ActionChip(
                    label: Text(act),
                    onPressed: _isStreaming ? null : () => _generate(act),
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
          onRetry: () => _generate(_lastAction),
        ),
      ],
    );
  }
}
