import 'package:flutter/material.dart';
import 'package:mozhivora/app/theme/tokens.dart';

enum MozhiBannerKind { info, success, warning, error }

/// Accessible inline status banner with semantic colors and optional action.
class MozhiStatusBanner extends StatelessWidget {
  const MozhiStatusBanner({
    super.key,
    required this.message,
    this.kind = MozhiBannerKind.info,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final MozhiBannerKind kind;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (Color color, IconData icon) = switch (kind) {
      MozhiBannerKind.info => (
          isDark ? MozhiTokens.inkTealBright : MozhiTokens.inkTeal,
          Icons.info_outline,
        ),
      MozhiBannerKind.success => (
          isDark ? MozhiTokens.successDark : MozhiTokens.successLight,
          Icons.check_circle_outline,
        ),
      MozhiBannerKind.warning => (
          isDark ? MozhiTokens.warningDark : MozhiTokens.warningLight,
          Icons.warning_amber_rounded,
        ),
      MozhiBannerKind.error => (
          isDark ? MozhiTokens.errorDark : MozhiTokens.errorLight,
          Icons.error_outline,
        ),
    };

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(MozhiTokens.space12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(MozhiTokens.radiusInput),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: MozhiTokens.space8),
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: MozhiTokens.space8),
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
