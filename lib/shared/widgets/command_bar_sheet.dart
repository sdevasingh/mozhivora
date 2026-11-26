import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

class CommandTarget {
  const CommandTarget({
    required this.route,
    required this.label,
    required this.icon,
    required this.keywords,
  });

  final String route;
  final String label;
  final IconData icon;
  final List<String> keywords;
}

Future<void> showCommandBarModal(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(MozhiTokens.radiusCard),
      ),
    ),
    builder: (ctx) => const _CommandBarContent(),
  );
}

class _CommandBarContent extends StatefulWidget {
  const _CommandBarContent();

  @override
  State<_CommandBarContent> createState() => _CommandBarContentState();
}

class _CommandBarContentState extends State<_CommandBarContent> {
  String _query = '';

  List<CommandTarget> _targets(AppLocalizations l10n) => [
        CommandTarget(
          route: '/',
          label: l10n.navHome,
          icon: Icons.home_outlined,
          keywords: ['home', 'dashboard'],
        ),
        CommandTarget(
          route: '/ask',
          label: l10n.navAsk,
          icon: Icons.auto_awesome_outlined,
          keywords: ['ask', 'chat', 'ai'],
        ),
        CommandTarget(
          route: '/writer',
          label: l10n.navWriter,
          icon: Icons.edit_note_outlined,
          keywords: ['writer', 'write', 'blog', 'draft'],
        ),
        CommandTarget(
          route: '/documents',
          label: l10n.navDocs,
          icon: Icons.description_outlined,
          keywords: ['pdf', 'docs', 'summarize', 'ocr'],
        ),
        CommandTarget(
          route: '/document-chat',
          label: l10n.navDocumentChat,
          icon: Icons.forum_outlined,
          keywords: ['document', 'chat', 'rag', 'citations'],
        ),
        CommandTarget(
          route: '/email',
          label: l10n.navEmail,
          icon: Icons.mail_outline,
          keywords: ['email', 'reply', 'outreach'],
        ),
        CommandTarget(
          route: '/notes',
          label: l10n.navNotes,
          icon: Icons.school_outlined,
          keywords: ['notes', 'study', 'flashcards', 'quiz'],
        ),
        CommandTarget(
          route: '/translator',
          label: l10n.navTranslator,
          icon: Icons.translate_outlined,
          keywords: ['translate', 'translator', 'hindi', 'urdu'],
        ),
        CommandTarget(
          route: '/voice',
          label: l10n.navVoice,
          icon: Icons.mic_none_outlined,
          keywords: ['voice', 'meeting', 'audio', 'transcript'],
        ),
        CommandTarget(
          route: '/tasks',
          label: l10n.navTasks,
          icon: Icons.check_circle_outline,
          keywords: ['task', 'planner', 'todo'],
        ),
        CommandTarget(
          route: '/templates',
          label: l10n.navTemplates,
          icon: Icons.grid_view_outlined,
          keywords: ['templates', 'gallery'],
        ),
        CommandTarget(
          route: '/workspace',
          label: l10n.navWorkspace,
          icon: Icons.folder_outlined,
          keywords: ['workspace', 'files', 'folders'],
        ),
        CommandTarget(
          route: '/settings',
          label: l10n.navSettings,
          icon: Icons.settings_outlined,
          keywords: ['settings', 'language', 'theme', 'privacy'],
        ),
        CommandTarget(
          route: '/pricing',
          label: l10n.navPricing,
          icon: Icons.workspace_premium_outlined,
          keywords: ['pricing', 'plans', 'credits', 'pro'],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final targets = _targets(l10n);
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? targets
        : targets
            .where(
              (t) =>
                  t.label.toLowerCase().contains(q) ||
                  t.keywords.any((k) => k.contains(q)),
            )
            .toList();

    return Padding(
      padding: EdgeInsets.only(
        left: MozhiTokens.space16,
        right: MozhiTokens.space16,
        top: MozhiTokens.space16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + MozhiTokens.space16,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 460),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.commandBarHint,
              ),
              onChanged: (val) => setState(() => _query = val),
              onSubmitted: (_) {
                if (filtered.isNotEmpty) {
                  final route = filtered.first.route;
                  Navigator.of(context).pop();
                  context.go(route);
                }
              },
            ),
            const SizedBox(height: MozhiTokens.space12),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.all(MozhiTokens.space24),
                child: Text(l10n.commandBarEmpty),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return ListTile(
                      leading: Icon(item.icon),
                      title: Text(item.label),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(item.route);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
