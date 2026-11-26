import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mozhivora/app/theme/tokens.dart';

/// Builds MOZHIVORA's Material 3 light (Paper) and dark (Charcoal) themes
/// with script-aware line heights and WCAG 2.2 AA contrast.
class MozhiTheme {
  static ThemeData light({
    required Locale locale,
    required bool reducedMotion,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: MozhiTokens.inkTeal,
        onPrimary: Colors.white,
        secondary: MozhiTokens.saffron,
        onSecondary: Colors.white,
        tertiary: MozhiTokens.terracotta,
        surface: MozhiTokens.paper,
        onSurface: MozhiTokens.ink,
        surfaceContainerLow: MozhiTokens.sand,
        surfaceContainerHighest: Colors.white,
        onSurfaceVariant: MozhiTokens.stone,
        outline: MozhiTokens.borderLight,
      ),
      scaffoldBackgroundColor: MozhiTokens.paper,
    );

    return _applyTypographyAndComponents(
      base: base,
      locale: locale,
      isDark: false,
      reducedMotion: reducedMotion,
    );
  }

  static ThemeData dark({
    required Locale locale,
    required bool reducedMotion,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF2EB5A8),
        onPrimary: MozhiTokens.charcoal,
        secondary: MozhiTokens.saffron,
        onSecondary: Colors.white,
        tertiary: Color(0xFFE07F5B),
        surface: MozhiTokens.charcoal,
        onSurface: MozhiTokens.paperDarkText,
        surfaceContainerLow: MozhiTokens.charcoalSurface,
        surfaceContainerHighest: Color(0xFF2E2A25),
        onSurfaceVariant: MozhiTokens.stoneDarkText,
        outline: MozhiTokens.charcoalBorder,
      ),
      scaffoldBackgroundColor: MozhiTokens.charcoal,
    );

    return _applyTypographyAndComponents(
      base: base,
      locale: locale,
      isDark: true,
      reducedMotion: reducedMotion,
    );
  }

  static ThemeData _applyTypographyAndComponents({
    required ThemeData base,
    required Locale locale,
    required bool isDark,
    required bool reducedMotion,
  }) {
    final onSurface = base.colorScheme.onSurface;
    final onSurfaceVariant = base.colorScheme.onSurfaceVariant;
    final isNonLatin = locale.languageCode != 'en';
    final bodyHeight = isNonLatin ? 1.7 : 1.5;

    final sansTextTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: onSurface,
      displayColor: onSurface,
    );

    final displayStyle = GoogleFonts.fraunces(
      color: onSurface,
      fontWeight: FontWeight.w700,
      height: isNonLatin ? 1.35 : 1.2,
    );

    final textTheme = sansTextTheme.copyWith(
      headlineLarge: displayStyle.copyWith(fontSize: 31.25),
      headlineMedium: displayStyle.copyWith(fontSize: 25),
      headlineSmall: displayStyle.copyWith(fontSize: 20),
      titleLarge: sansTextTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: bodyHeight,
      ),
      bodyLarge: sansTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        height: bodyHeight,
      ),
      bodyMedium: sansTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        height: bodyHeight,
      ),
      bodySmall: sansTextTheme.bodySmall?.copyWith(
        fontSize: 12.8,
        color: onSurfaceVariant,
        height: bodyHeight,
      ),
    );

    final borderColor = base.colorScheme.outline;

    return base.copyWith(
      textTheme: textTheme,
      pageTransitionsTheme: reducedMotion
          ? const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: _NoTransitionBuilder(),
                TargetPlatform.windows: _NoTransitionBuilder(),
                TargetPlatform.linux: _NoTransitionBuilder(),
                TargetPlatform.macOS: _NoTransitionBuilder(),
              },
            )
          : base.pageTransitionsTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        color: base.colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: borderColor, width: 1.2),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: base.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: base.colorScheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          side: BorderSide(color: borderColor, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      dividerTheme:
          DividerThemeData(color: borderColor, thickness: 1, space: 1),
    );
  }
}

class _NoTransitionBuilder extends PageTransitionsBuilder {
  const _NoTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
