import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';

class Sm2Flashcard {
  Sm2Flashcard({
    required this.front,
    required this.back,
    this.intervalDays = 1,
    this.easeFactor = 2.5,
  });

  final String front;
  final String back;
  int intervalDays;
  double easeFactor;

  void review(int quality) {
    if (quality < 3) {
      intervalDays = 1;
    } else {
      intervalDays =
          intervalDays == 1 ? 3 : (intervalDays * easeFactor).round();
    }
    easeFactor = (easeFactor + (0.1 - (5 - quality) * 0.08)).clamp(1.3, 3.0);
  }
}

class NotesStudyScreen extends ConsumerStatefulWidget {
  const NotesStudyScreen({super.key});

  @override
  ConsumerState<NotesStudyScreen> createState() => _NotesStudyScreenState();
}

class _NotesStudyScreenState extends ConsumerState<NotesStudyScreen> {
  final _sourceCtrl = TextEditingController();
  String _studyMode = 'Structured Notes';
  String _output = '';
  bool _isStreaming = false;
  String? _error;
  bool _isConfigError = false;

  // Interactive SM-2 flashcard deck + Exam countdown
  final List<Sm2Flashcard> _deck = [
    Sm2Flashcard(
      front: 'What is the primary goal of spaced repetition (SM-2)?',
      back:
          'Reviewing concepts right before you forget them to maximize long-term retention.',
    ),
    Sm2Flashcard(
      front: 'Which Indian Act governs personal data protection in MOZHIVORA?',
      back: 'India Digital Personal Data Protection (DPDP) Act 2023.',
    ),
  ];
  int _cardIndex = 0;
  bool _showBack = false;
  DateTime _examDate = DateTime.now().add(const Duration(days: 14));

  @override
  void dispose() {
    _sourceCtrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final text = _sourceCtrl.text.trim();
    if (text.isEmpty || _isStreaming) return;

    final prompt =
        'Create $_studyMode from the following study material:\n\n$text';
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
                tool: 'notes',
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

  void _gradeCard(int quality) {
    setState(() {
      _deck[_cardIndex].review(quality);
      _showBack = false;
      _cardIndex = (_cardIndex + 1) % _deck.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final estimated = AiGatewayClient.estimateCredits(prompt: _sourceCtrl.text);
    final daysLeft = _examDate.difference(DateTime.now()).inDays.clamp(0, 365);
    final currentCard = _deck[_cardIndex];

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.navNotes,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            CreditCostPill(credits: estimated),
          ],
        ),
        const SizedBox(height: MozhiTokens.space16),

        // Exam Countdown Card
        Card(
          child: ListTile(
            leading:
                Icon(Icons.event_outlined, color: theme.colorScheme.tertiary),
            title: Text('Exam Countdown: $daysLeft days left'),
            subtitle: const Text('Tap to adjust your target exam date'),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _examDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _examDate = picked);
            },
          ),
        ),
        const SizedBox(height: MozhiTokens.space16),

        // Study Generator
        Card(
          child: Padding(
            padding: const EdgeInsets.all(MozhiTokens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                        value: 'Structured Notes', label: Text('Notes')),
                    ButtonSegment(
                        value: 'Flashcards (Q&A)', label: Text('Flashcards')),
                    ButtonSegment(
                        value: '5-Question Quiz', label: Text('Quiz')),
                  ],
                  selected: {_studyMode},
                  onSelectionChanged: (s) =>
                      setState(() => _studyMode = s.first),
                ),
                const SizedBox(height: MozhiTokens.space12),
                TextField(
                  controller: _sourceCtrl,
                  minLines: 3,
                  maxLines: 6,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(labelText: l10n.notesSourceLabel),
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

        // Interactive SM-2 Flashcard Deck
        Text('SM-2 Spaced Repetition Deck', style: theme.textTheme.titleMedium),
        const SizedBox(height: MozhiTokens.space8),
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(MozhiTokens.radiusCard),
            onTap: () => setState(() => _showBack = !_showBack),
            child: Padding(
              padding: const EdgeInsets.all(MozhiTokens.space24),
              child: Column(
                children: [
                  Text(
                    _showBack ? currentCard.back : currentCard.front,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: MozhiTokens.space12),
                  Text(
                    _showBack
                        ? 'Interval: ${currentCard.intervalDays}d · Rate recall:'
                        : 'Tap card to reveal answer',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (_showBack) ...[
                    const SizedBox(height: MozhiTokens.space12),
                    Wrap(
                      spacing: MozhiTokens.space8,
                      children: [
                        OutlinedButton(
                          onPressed: () => _gradeCard(1),
                          child: const Text('Again'),
                        ),
                        OutlinedButton(
                          onPressed: () => _gradeCard(4),
                          child: const Text('Good'),
                        ),
                        FilledButton(
                          onPressed: () => _gradeCard(5),
                          child: const Text('Easy'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
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
