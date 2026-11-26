import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/features/task_planner/data/task_provider.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
  String _search = '';
  bool _showTrash = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tasks = ref.watch(taskListProvider);
    final filtered = tasks
        .where((t) =>
            _search.isEmpty ||
            t.title.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.navWorkspace,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                final exportJson = jsonEncode({
                  'exportedAt': DateTime.now().toIso8601String(),
                  'tasks': tasks.map((t) => t.toJson()).toList(),
                });
                Clipboard.setData(ClipboardData(text: exportJson));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.workspaceExported)),
                );
              },
              icon: const Icon(Icons.download_outlined),
              label: Text(l10n.workspaceExportBtn),
            ),
          ],
        ),
        const SizedBox(height: MozhiTokens.space16),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: l10n.workspaceSearchHint,
          ),
          onChanged: (v) => setState(() => _search = v),
        ),
        const SizedBox(height: MozhiTokens.space12),
        FilterChip(
          label: Text(l10n.workspaceTrashToggle),
          selected: _showTrash,
          onSelected: (v) => setState(() => _showTrash = v),
        ),
        const SizedBox(height: MozhiTokens.space16),
        if (filtered.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(MozhiTokens.space24),
              child: Text(l10n.emptyWorkspaceDesc),
            ),
          )
        else
          ...filtered.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: MozhiTokens.space8),
              child: ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text(item.title),
                subtitle: Text(
                    'Updated ${item.updatedAt.toLocal().toString().split('.').first}'),
                trailing: IconButton(
                  tooltip: l10n.workspaceShareLink,
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    final shareUrl = 'https://mozhivora.app/share/${item.id}';
                    Clipboard.setData(ClipboardData(text: shareUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Copied read-only link: $shareUrl')),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
