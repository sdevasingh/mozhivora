import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mozhivora/app/theme/tokens.dart';

/// Builds MOZHIVORA's Material 3 light (Paper) and dark (Obsidian) themes
/// using the 12/14/16/20/24/32/40 type scale and WCAG 2.2 AA contrast.
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
        onSecondary: MozhiTokens.charcoal,
        tertiary: MozhiTokens.terracotta,
        error: MozhiTokens.errorLight,
        onError: Colors.white,
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
        primary: MozhiTokens.inkTealBright,
        onPrimary: MozhiTokens.charcoal,
        secondary: MozhiTokens.saffron,
        onSecondary: MozhiTokens.charcoal,
        tertiary: Color(0xFFE07F5B),
        error: MozhiTokens.errorDark,
        onError: MozhiTokens.charcoal,
        surface: MozhiTokens.charcoal,
        onSurface: MozhiTokens.paperDarkText,
        surfaceContainerLow: MozhiTokens.charcoalSurface,
        surfaceContainerHighest: Color(0xFF28262B),
        onSurfaceVariant: MozhiTokens.stoneDarkText,
        outline: MozhiTokens.charcoalBorder,
      ),
      scaffoldBackgroundColor: MozhiTokens.charcoal,
    );

    return _applyTypographyAndComponents(
      base: base,
      locale: locale,
      reducedMotion: reducedMotion,
    );
  }

  static ThemeData _applyTypographyAndComponents({
    required ThemeData base,
    required Locale locale,
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

    final displayStyle = GoogleFonts.spaceGrotesk(
      color: onSurface,
      fontWeight: FontWeight.w700,
      height: isNonLatin ? 1.35 : 1.15,
    );

    // Strict Type Scale: 12 / 14 / 16 / 20 / 24 / 32 / 40
    final textTheme = sansTextTheme.copyWith(
      displaySmall: displayStyle.copyWith(fontSize: MozhiTokens.text40),
      headlineLarge: displayStyle.copyWith(fontSize: MozhiTokens.text32),
      headlineMedium: displayStyle.copyWith(fontSize: MozhiTokens.text24),
      headlineSmall: displayStyle.copyWith(fontSize: MozhiTokens.text20),
      titleLarge: sansTextTheme.titleLarge?.copyWith(
        fontSize: MozhiTokens.text20,
        fontWeight: FontWeight.w600,
        height: bodyHeight,
      ),
      titleMedium: sansTextTheme.titleMedium?.copyWith(
        fontSize: MozhiTokens.text16,
        fontWeight: FontWeight.w600,
        height: bodyHeight,
      ),
      bodyLarge: sansTextTheme.bodyLarge?.copyWith(
        fontSize: MozhiTokens.text16,
        height: bodyHeight,
      ),
      bodyMedium: sansTextTheme.bodyMedium?.copyWith(
        fontSize: MozhiTokens.text14,
        height: bodyHeight,
      ),
      bodySmall: sansTextTheme.bodySmall?.copyWith(
        fontSize: MozhiTokens.text12,
        color: onSurfaceVariant,
        height: bodyHeight,
      ),
      labelSmall: sansTextTheme.labelSmall?.copyWith(
        fontSize: MozhiTokens.text12,
        color: onSurfaceVariant,
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
          borderRadius: BorderRadius.circular(MozhiTokens.radiusCard),
          side: BorderSide(color: borderColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: base.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MozhiTokens.radiusInput),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MozhiTokens.radiusInput),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MozhiTokens.radiusInput),
          borderSide: BorderSide(color: base.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MozhiTokens.radiusInput),
          borderSide: BorderSide(color: base.colorScheme.error, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MozhiTokens.radiusInput),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MozhiTokens.radiusInput),
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
