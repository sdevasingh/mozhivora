import 'package:flutter/material.dart';

/// MOZHIVORA Design Tokens — Warm Editorial System
/// Shared conceptually with `web_marketing/src/styles/tokens.css`.
abstract final class MozhiTokens {
  // Colors
  static const Color paper = Color(0xFFF4F1E9);
  static const Color inkTeal = Color(0xFF15857A);
  static const Color inkTealDark = Color(0xFF0F665E);
  static const Color saffron = Color(0xFFFF6A3B);
  static const Color terracotta = Color(0xFFC0623E);
  static const Color ink = Color(0xFF26241F);
  static const Color stone = Color(0xFF5A5550);
  static const Color sand = Color(0xFFF0EDE5);
  static const Color borderLight = Color(0xFFDED8CC);
  static const Color charcoal = Color(0xFF1C1A17);
  static const Color charcoalSurface = Color(0xFF26231F);
  static const Color charcoalBorder = Color(0xFF3A352F);
  static const Color paperDarkText = Color(0xFFF4F1E9);
  static const Color stoneDarkText = Color(0xFFB8B1A9);

  // 8-point spacing grid
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space48 = 48;
  static const double space64 = 64;

  // Radii
  static const double radiusInput = 6;
  static const double radiusCard = 12;
  static const double radiusHero = 24;

  // Motion durations
  static const Duration motionHover = Duration(milliseconds: 180);
  static const Duration motionEntrance = Duration(milliseconds: 240);
  static const Duration motionLayout = Duration(milliseconds: 320);
  static const Curve motionCurve = Curves.easeOut;

  // Layout constraints
  static const double maxReadingWidth = 880;
  static const double desktopBreakpoint = 840;
}
