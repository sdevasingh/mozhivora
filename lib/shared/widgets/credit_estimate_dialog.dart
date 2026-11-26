import 'package:flutter/material.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

/// Shows a transparent credit cost badge and requires confirmation above 1 credit.
Future<bool> confirmCreditCostIfNeeded(
  BuildContext context, {
  required int estimatedCredits,
}) async {
  if (estimatedCredits <= 1) return true;
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.creditConfirmTitle),
      content: Text(l10n.creditConfirmBody(estimatedCredits)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: MozhiTokens.saffron),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.creditConfirmContinue),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

class CreditCostPill extends StatelessWidget {
  const CreditCostPill({super.key, required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_outlined, size: 15, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            l10n.creditEstimateLabel(credits),
            style: theme.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
