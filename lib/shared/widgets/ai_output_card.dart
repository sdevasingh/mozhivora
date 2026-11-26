import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

class AiOutputCard extends StatelessWidget {
  const AiOutputCard({
    super.key,
    required this.output,
    required this.isStreaming,
    this.errorMessage,
    this.isConfigError = false,
  });

  final String output;
  final bool isStreaming;
  final String? errorMessage;
  final bool isConfigError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (errorMessage != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(MozhiTokens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: MozhiTokens.space8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ),
              if (isConfigError) ...[
                const SizedBox(height: MozhiTokens.space12),
                OutlinedButton(
                  onPressed: () => context.go('/auth'),
                  child: Text(l10n.authSignIn),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (output.isEmpty && !isStreaming) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(MozhiTokens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isStreaming)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    const SizedBox(width: MozhiTokens.space8),
                    Text(
                      isStreaming ? l10n.aiStreamingLabel : l10n.aiResultLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (output.isNotEmpty)
                  IconButton(
                    tooltip: l10n.actionCopy,
                    icon: const Icon(Icons.copy_outlined, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: output));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.copiedToClipboard)),
                      );
                    },
                  ),
              ],
            ),
            const Divider(),
            const SizedBox(height: MozhiTokens.space8),
            SelectableText(output, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
