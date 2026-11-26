import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mozhivora/app/theme/tokens.dart';

/// Glassmorphic frosted container with subtle specular border & ambient depth.
class AtelierBox extends StatelessWidget {
  const AtelierBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(MozhiTokens.space16),
    this.color,
    this.borderColor,
    this.offsetShadow = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final bool offsetShadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = color ??
        (isDark
            ? Colors.white.withValues(alpha: 0.045)
            : theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.85));
    final border = borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: offsetShadow ? 0.24 : 0.12)
            : theme.colorScheme.outline);

    final inner = Material(
      type: MaterialType.transparency,
      child: onTap != null
          ? InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
              child: Padding(padding: padding, child: child),
            )
          : Padding(padding: padding, child: child),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: offsetShadow ? 1.5 : 1),
            boxShadow: offsetShadow && isDark
                ? [
                    BoxShadow(
                      color: MozhiTokens.inkTeal.withValues(alpha: 0.16),
                      blurRadius: 32,
                      spreadRadius: -4,
                    ),
                  ]
                : null,
          ),
          child: inner,
        ),
      ),
    );
  }
}

/// Jomor-style hollow outline / stroke display text.
class OutlinedDisplayText extends StatelessWidget {
  const OutlinedDisplayText(
    this.text, {
    super.key,
    this.fontSize = 44,
    this.strokeColor,
  });

  final String text;
  final double fontSize;
  final Color? strokeColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = strokeColor ??
        (isDark ? Colors.white.withValues(alpha: 0.85) : MozhiTokens.ink);
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        height: 0.98,
        letterSpacing: -1.2,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = color,
      ),
    );
  }
}

/// Jomor-style circular ringed CTA button.
class CircularRingCta extends StatelessWidget {
  const CircularRingCta({
    super.key,
    required this.label,
    required this.onTap,
    this.size = 92,
  });

  final String label;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(size / 2),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2EB5A8), width: 1.5),
          color: const Color(0xFF2EB5A8).withValues(alpha: 0.08),
        ),
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: -0.18,
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// Editorial masthead header used across tools.
class AtelierPageHeader extends StatelessWidget {
  const AtelierPageHeader({
    super.key,
    required this.indexTag,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String indexTag;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: MozhiTokens.space16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 44,
            margin: const EdgeInsetsDirectional.only(end: MozhiTokens.space12),
            color: MozhiTokens.saffron,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  indexTag.toUpperCase(),
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: MozhiTokens.terracotta,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
