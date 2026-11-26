import 'package:flutter/material.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

class CreditsRingCard extends StatelessWidget {
  const CreditsRingCard({
    super.key,
    required this.remaining,
    required this.total,
    required this.resetDateLabel,
  });

  final int remaining;
  final int total;
  final String resetDateLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final progress = total > 0 ? (remaining / total).clamp(0.0, 1.0) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(MozhiTokens.space16),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 5,
                    backgroundColor:
                        theme.colorScheme.outline.withValues(alpha: 0.4),
                    color: theme.colorScheme.primary,
                  ),
                  Text(
                    '$remaining',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: MozhiTokens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.creditsRemaining(remaining),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.creditsResetOn(resetDateLabel),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
