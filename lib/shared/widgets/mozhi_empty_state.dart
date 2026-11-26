import 'package:flutter/material.dart';
import 'package:mozhivora/app/theme/tokens.dart';

class MozhiEmptyState extends StatelessWidget {
  const MozhiEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.samplePrompts = const [],
    this.onPromptTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> samplePrompts;
  final ValueChanged<String>? onPromptTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(MozhiTokens.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 28),
            ),
            const SizedBox(height: MozhiTokens.space16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: MozhiTokens.space8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (samplePrompts.isNotEmpty) ...[
              const SizedBox(height: MozhiTokens.space16),
              Wrap(
                spacing: MozhiTokens.space8,
                runSpacing: MozhiTokens.space8,
                alignment: WrapAlignment.center,
                children: samplePrompts
                    .map(
                      (prompt) => ActionChip(
                        label: Text(prompt),
                        onPressed: onPromptTap != null
                            ? () => onPromptTap!(prompt)
                            : null,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
