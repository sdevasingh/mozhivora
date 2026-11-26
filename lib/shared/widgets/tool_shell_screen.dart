import 'package:flutter/material.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/mozhi_empty_state.dart';

class ToolShellScreen extends StatelessWidget {
  const ToolShellScreen({
    super.key,
    required this.title,
    required this.icon,
    this.samplePrompts = const [],
  });

  final String title;
  final IconData icon;
  final List<String> samplePrompts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: MozhiTokens.space16),
        MozhiEmptyState(
          icon: icon,
          title: l10n.emptyWorkspaceTitle,
          subtitle: l10n.toolPhaseReady,
          samplePrompts: samplePrompts,
          onPromptTap: (prompt) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(prompt)),
            );
          },
        ),
      ],
    );
  }
}
