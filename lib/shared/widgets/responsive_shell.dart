import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/animated_background.dart';
import 'package:mozhivora/shared/widgets/command_bar_sheet.dart';

class NavDestination {
  const NavDestination({
    required this.index,
    required this.route,
    required this.label,
    required this.icon,
  });

  final String index;
  final String route;
  final String label;
  final IconData icon;
}

class ResponsiveShell extends ConsumerStatefulWidget {
  const ResponsiveShell({
    super.key,
    required this.currentRoute,
    required this.child,
  });

  final String currentRoute;
  final Widget child;

  @override
  ConsumerState<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends ConsumerState<ResponsiveShell> {
  List<NavDestination> _allDestinations(AppLocalizations l10n) => [
        NavDestination(
            index: '00',
            route: '/',
            label: l10n.navHome,
            icon: Icons.home_outlined),
        NavDestination(
            index: '01',
            route: '/ask',
            label: l10n.navAsk,
            icon: Icons.auto_awesome_outlined),
        NavDestination(
            index: '02',
            route: '/writer',
            label: l10n.navWriter,
            icon: Icons.edit_note_outlined),
        NavDestination(
            index: '03',
            route: '/email',
            label: l10n.navEmail,
            icon: Icons.mail_outline),
        NavDestination(
            index: '04',
            route: '/translator',
            label: l10n.navTranslator,
            icon: Icons.translate_outlined),
        NavDestination(
            index: '05',
            route: '/documents',
            label: l10n.navDocs,
            icon: Icons.description_outlined),
        NavDestination(
            index: '06',
            route: '/document-chat',
            label: l10n.navDocumentChat,
            icon: Icons.forum_outlined),
        NavDestination(
            index: '07',
            route: '/notes',
            label: l10n.navNotes,
            icon: Icons.school_outlined),
        NavDestination(
            index: '08',
            route: '/voice',
            label: l10n.navVoice,
            icon: Icons.mic_none_outlined),
        NavDestination(
            index: '09',
            route: '/tasks',
            label: l10n.navTasks,
            icon: Icons.check_circle_outline),
        NavDestination(
            index: '10',
            route: '/templates',
            label: l10n.navTemplates,
            icon: Icons.grid_view_outlined),
        NavDestination(
            index: '11',
            route: '/workspace',
            label: l10n.navWorkspace,
            icon: Icons.folder_outlined),
        NavDestination(
            index: '12',
            route: '/settings',
            label: l10n.navSettings,
            icon: Icons.settings_outlined),
        NavDestination(
            index: '13',
            route: '/pricing',
            label: l10n.navPricing,
            icon: Icons.workspace_premium_outlined),
      ];

  void _openFullMenu(BuildContext context, List<NavDestination> destinations) {
    final theme = Theme.of(context);
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Menu',
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, _, __) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(MozhiTokens.space32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '✦ MOZHIVORA INDEX',
                          style: GoogleFonts.ibmPlexMono(
                            color: MozhiTokens.saffron,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => Navigator.of(ctx).pop(),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child:
                                const Icon(Icons.close, color: MozhiTokens.ink),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: MozhiTokens.space24),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 320,
                          childAspectRatio: 3.4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: destinations.length,
                        itemBuilder: (context, i) {
                          final d = destinations[i];
                          final active = widget.currentRoute == d.route;
                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.of(ctx).pop();
                              context.go(d.route);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: active
                                      ? MozhiTokens.saffron
                                      : Colors.white.withValues(alpha: 0.16),
                                ),
                                color: active
                                    ? MozhiTokens.saffron
                                        .withValues(alpha: 0.15)
                                    : Colors.white.withValues(alpha: 0.04),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    d.index,
                                    style: GoogleFonts.ibmPlexMono(
                                      color: MozhiTokens.saffron,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Icon(d.icon, color: Colors.white70, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      d.label,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= MozhiTokens.desktopBreakpoint;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            showCommandBarModal(context),
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
            showCommandBarModal(context),
      },
      child: Focus(
        autofocus: true,
        child: isDesktop
            ? _buildDesktop(context, l10n, theme)
            : _buildMobile(context, l10n, theme),
      ),
    );
  }

  Widget _buildDesktop(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final destinations = _allDestinations(l10n);
    final prefs = ref.watch(appPreferencesProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(reducedMotion: prefs.reducedMotion),
          Column(
            children: [
              // Minimalist Jomor Top Navigation Bar (no heavy sidebar!)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MozhiTokens.space32,
                  vertical: MozhiTokens.space16,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.go('/'),
                      child: Row(
                        children: [
                          const Text(
                            '✦',
                            style: TextStyle(
                              color: Color(0xFFD4FF4E),
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.appTitle,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: MozhiTokens.space24),
                    // Quick horizontal top links (Ask, Writer, Docs, Translator)
                    for (final quick in [
                      ('/', l10n.navHome),
                      ('/ask', l10n.navAsk),
                      ('/writer', l10n.navWriter),
                      ('/documents', l10n.navDocs),
                      ('/translator', l10n.navTranslator),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: TextButton(
                          onPressed: () => context.go(quick.$1),
                          child: Text(
                            quick.$2.toUpperCase(),
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: widget.currentRoute == quick.$1
                                  ? MozhiTokens.saffron
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    // Glass Ctrl+K pill
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => showCommandBarModal(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.06),
                          border: Border.all(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.14),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 15),
                            const SizedBox(width: 8),
                            Text(
                              l10n.commandBarShortcut,
                              style: GoogleFonts.ibmPlexMono(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Locale pill
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => context.go('/settings'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.14),
                          ),
                        ),
                        child: Text(
                          prefs.locale.languageCode.toUpperCase(),
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Jomor signature circular "=" menu button
                    InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => _openFullMenu(context, destinations),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.white : MozhiTokens.ink,
                        ),
                        child: Icon(
                          Icons.drag_handle,
                          color: isDark ? MozhiTokens.ink : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: widget.child,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final mobileRoutes = ['/', '/templates', '/ask', '/workspace', '/settings'];
    final currentIdx = mobileRoutes.indexOf(widget.currentRoute);

    final prefs = ref.watch(appPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: MozhiTokens.space16,
        title: Row(
          children: [
            const Text('✦ ', style: TextStyle(color: Color(0xFFD4FF4E))),
            Text(
              l10n.appTitle,
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.commandBarHint,
            icon: const Icon(Icons.search),
            onPressed: () => showCommandBarModal(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedBackground(reducedMotion: prefs.reducedMotion),
          widget.child,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.navAsk,
        backgroundColor: MozhiTokens.saffron,
        foregroundColor: Colors.white,
        onPressed: () => showCommandBarModal(context),
        child: const Icon(Icons.auto_awesome),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIdx < 0 ? 0 : currentIdx,
        onDestinationSelected: (idx) => context.go(mobileRoutes[idx]),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.apps_outlined),
            label: l10n.navTools,
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            label: l10n.navAsk,
          ),
          NavigationDestination(
            icon: const Icon(Icons.folder_outlined),
            label: l10n.navWorkspace,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
