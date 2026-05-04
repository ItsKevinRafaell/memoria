// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

/// ─────────────────────────────────────────
///  Design System Tokens
/// ─────────────────────────────────────────
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color white = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textDisabled = Color(0xFFCBD5E1); // Slate 300

  // Accent / Action
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryLight = Color(0xFFEFF4FF); // Blue 50 tint

  // Pastels
  static const Color softPeach = Color(0xFFFFEDD5);
  static const Color softMint = Color(0xFFD1FAE5);
  static const Color softLavender = Color(0xFFEDE9FE);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF97316);
  static const Color success = Color(0xFF22C55E);

  // Nav / Inactive
  static const Color navInactive = Color(0xFF94A3B8);
}

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Poppins';

  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  // Labels / Buttons
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.5,
  );

  static const TextStyle buttonLabelDark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
}

class AppRadius {
  AppRadius._();

  static const double pill = 9999;
  static const double card = 24;
  static const double cardSm = 16;
  static const double button = 9999;
  static const double chip = 8;
  static const double xl = 32;
  static const double full = 9999;

  static const List<BoxShadow> modal = [
    BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const Color primaryPastel = Color(0xFFE3F2FD);
  static const Color border = Color(0xFFBDBDBD);
}

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: -1,
    ),
  ];
}
