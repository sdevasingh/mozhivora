import 'package:flutter/material.dart';

/// MOZHIVORA Design System Tokens
/// Color, Type Scale (12/14/16/20/24/32/40), 4px/8px Spacing, Radii & Motion.
abstract final class MozhiTokens {
  // Brand & Surface Colors
  static const Color paper = Color(0xFFF4F1E9);
  static const Color inkTeal = Color(0xFF15857A);
  static const Color inkTealDark = Color(0xFF0F665E);
  static const Color inkTealBright = Color(0xFF2EB5A8);
  static const Color saffron = Color(0xFFFF6A3B);
  static const Color terracotta = Color(0xFFC0623E);
  static const Color ink = Color(0xFF26241F);
  static const Color stone = Color(0xFF5A5550);
  static const Color sand = Color(0xFFF0EDE5);
  static const Color borderLight = Color(0xFFDED8CC);
  static const Color charcoal = Color(0xFF121214);
  static const Color charcoalSurface = Color(0xFF1C1B1E);
  static const Color charcoalBorder = Color(0xFF333136);
  static const Color paperDarkText = Color(0xFFF4F1E9);
  static const Color stoneDarkText = Color(0xFFB8B1A9);

  // Semantic Status Colors (WCAG AA compliant)
  static const Color successLight = Color(0xFF137333);
  static const Color successDark = Color(0xFF5BB974);
  static const Color warningLight = Color(0xFFB06000);
  static const Color warningDark = Color(0xFFFDD663);
  static const Color errorLight = Color(0xFFB3261E);
  static const Color errorDark = Color(0xFFF28B82);

  // Type Scale (12 / 14 / 16 / 20 / 24 / 32 / 40)
  static const double text12 = 12;
  static const double text14 = 14;
  static const double text16 = 16;
  static const double text20 = 20;
  static const double text24 = 24;
  static const double text32 = 32;
  static const double text40 = 40;

  // Spacing Scale (4px / 8px units)
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space48 = 48;
  static const double space64 = 64;

  // Radii & Elevation
  static const double radiusInput = 8;
  static const double radiusCard = 12;
  static const double radiusHero = 20;

  // Motion (150-300ms ease-out)
  static const Duration motionHover = Duration(milliseconds: 180);
  static const Duration motionEntrance = Duration(milliseconds: 240);
  static const Duration motionLayout = Duration(milliseconds: 280);
  static const Curve motionCurve = Curves.easeOut;

  // Layout Constraints
  static const double maxReadingWidth = 880;
  static const double desktopBreakpoint = 840;
}
