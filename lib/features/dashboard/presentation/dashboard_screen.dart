import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/atelier_frame.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _quickAskCtrl = TextEditingController();

  @override
  void dispose() {
    _quickAskCtrl.dispose();
    super.dispose();
  }

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 17) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  void _launchQuickAsk() {
    final q = _quickAskCtrl.text.trim();
    if (q.isEmpty) {
      context.go('/ask');
    } else {
      _quickAskCtrl.clear();
      context.go('/ask', extra: q);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final prefs = ref.watch(appPreferencesProvider);
    final isStudent = prefs.workspaceMode == WorkspaceMode.student;
    final isWide = MediaQuery.sizeOf(context).width >= 760;
    final resetDate = DateFormat.yMMMd(prefs.locale.languageCode)
        .format(DateTime.now().add(const Duration(days: 1)));

    final quickActions = isStudent
        ? [
            ('01', l10n.navNotes, Icons.school_outlined, '/notes'),
            ('02', l10n.navDocs, Icons.description_outlined, '/documents'),
            ('03', l10n.navTranslator, Icons.translate_outlined, '/translator'),
            ('04', l10n.navAsk, Icons.auto_awesome_outlined, '/ask'),
          ]
        : [
            ('01', l10n.navWriter, Icons.edit_note_outlined, '/writer'),
            ('02', l10n.navEmail, Icons.mail_outline, '/email'),
            ('03', l10n.navVoice, Icons.mic_none_outlined, '/voice'),
            (
              '04',
              l10n.navDocumentChat,
              Icons.forum_outlined,
              '/document-chat'
            ),
          ];

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: MozhiTokens.space24,
        vertical: MozhiTokens.space16,
      ),
      children: [
        // Jomor × T.RICKS Asymmetric Hero
        AtelierBox(
          offsetShadow: true,
          padding: const EdgeInsets.all(MozhiTokens.space24),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildHeroLeft(
                          context, l10n, theme, prefs, isStudent),
                    ),
                    const SizedBox(width: MozhiTokens.space24),
                    Expanded(
                      flex: 2,
                      child: _buildFloatingGlassCard(
                          context, l10n, theme, prefs, resetDate),
                    ),
                    const SizedBox(width: MozhiTokens.space12),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        'WORKSPACE + AI // 11 LANGUAGES',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 10,
                          letterSpacing: 2.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroLeft(context, l10n, theme, prefs, isStudent),
                    const SizedBox(height: MozhiTokens.space24),
                    _buildFloatingGlassCard(
                        context, l10n, theme, prefs, resetDate),
                  ],
                ),
        ),
        const SizedBox(height: MozhiTokens.space32),

        // Quick Actions with Jomor Watermark Numbers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.quickActions,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            CircularRingCta(
              label: l10n.navAsk,
              size: 70,
              onTap: () => context.go('/ask'),
            ),
          ],
        ),
        const SizedBox(height: MozhiTokens.space16),
        GridView.count(
          crossAxisCount: isWide ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: MozhiTokens.space12,
          crossAxisSpacing: MozhiTokens.space12,
          childAspectRatio: 1.25,
          children: quickActions.map((action) {
            return AtelierBox(
              onTap: () => context.go(action.$4),
              child: Stack(
                children: [
                  Positioned(
                    right: -4,
                    bottom: -10,
                    child: Text(
                      action.$1,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 58,
                        fontWeight: FontWeight.w800,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1.0
                          ..color = theme.colorScheme.onSurface
                              .withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(action.$3, color: const Color(0xFF2EB5A8), size: 22),
                      Text(
                        action.$2,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: MozhiTokens.space24),

        // Time saved + Today's tasks
        AtelierBox(
          padding: EdgeInsets.zero,
          child: ListTile(
            leading: const Icon(Icons.check_circle_outline,
                color: Color(0xFF2EB5A8)),
            title: Text(l10n.todaysTasks),
            subtitle: Text(l10n.noTasksToday),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => context.go('/tasks'),
          ),
        ),
        const SizedBox(height: MozhiTokens.space12),
        AtelierBox(
          child: Row(
            children: [
              const Icon(Icons.timer_outlined, color: MozhiTokens.saffron),
              const SizedBox(width: MozhiTokens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.timeSavedTitle,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      l10n.timeSavedLocked(
                          (5 - prefs.generationCount).clamp(1, 5)),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: MozhiTokens.space16),

        if (!prefs.upgradeCardDismissed)
          AtelierBox(
            borderColor: MozhiTokens.saffron.withValues(alpha: 0.6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.upgradeCardTitle,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(l10n.upgradeCardSubtitle,
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(appPreferencesProvider.notifier)
                      .dismissUpgradeCard(),
                  child: Text(l10n.dismiss),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: MozhiTokens.saffron),
                  onPressed: () => context.go('/pricing'),
                  child: Text(l10n.upgradeAction),
                ),
              ],
            ),
          ),
        const SizedBox(height: MozhiTokens.space24),
        Center(
          child: Text(
            l10n.privacyPromise,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroLeft(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    AppPreferencesState prefs,
    bool isStudent,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: Text(l10n.modeStudent),
              selected: isStudent,
              onSelected: (_) => ref
                  .read(appPreferencesProvider.notifier)
                  .setWorkspaceMode(WorkspaceMode.student),
            ),
            ChoiceChip(
              label: Text(l10n.modePro),
              selected: !isStudent,
              onSelected: (_) => ref
                  .read(appPreferencesProvider.notifier)
                  .setWorkspaceMode(WorkspaceMode.pro),
            ),
          ],
        ),
        const SizedBox(height: MozhiTokens.space16),
        OutlinedDisplayText(_greeting(l10n).toUpperCase(), fontSize: 38),
        Text(
          'MOZHIVORA',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 42,
            fontWeight: FontWeight.w800,
            height: 1.0,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: MozhiTokens.space8),
        Text(l10n.tagline, style: theme.textTheme.bodyMedium),
        const SizedBox(height: MozhiTokens.space16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _quickAskCtrl,
                onSubmitted: (_) => _launchQuickAsk(),
                decoration: InputDecoration(
                  hintText: l10n.askSubtitle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _launchQuickAsk,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.arrow_forward, color: MozhiTokens.ink),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingGlassCard(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    AppPreferencesState prefs,
    String resetDate,
  ) {
    return Transform.rotate(
      angle: -0.04,
      child: Container(
        padding: const EdgeInsets.all(MozhiTokens.space24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MozhiTokens.inkTeal.withValues(alpha: 0.45),
              MozhiTokens.saffron.withValues(alpha: 0.25),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.28),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: MozhiTokens.inkTeal.withValues(alpha: 0.22),
              blurRadius: 36,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Transform(
          transform: Matrix4.rotationZ(0.04 * math.pi / 180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MOZHIVORA PASS',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text('✦',
                      style: TextStyle(fontSize: 20, color: Color(0xFFD4FF4E))),
                ],
              ),
              const SizedBox(height: MozhiTokens.space24),
              Text(
                l10n.creditsRemaining(prefs.creditsRemaining),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.creditsResetOn(resetDate),
                style: GoogleFonts.ibmPlexMono(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
