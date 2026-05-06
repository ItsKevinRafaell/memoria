// lib/utils/app_theme.dart
// Central theme definition — Material 3 with a deep space palette.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color background     = Color(0xFF0D0D1A); // Deep midnight navy
  static const Color surface        = Color(0xFF1A1A2E); // Card backgrounds
  static const Color surfaceVariant = Color(0xFF16213E); // Slightly lighter
  static const Color cardBack       = Color(0xFF1F1F3F); // Face-down card
  static const Color accent         = Color(0xFF7C4DFF); // Electric violet
  static const Color accentLight    = Color(0xFFB39DDB); // Soft lavender
  static const Color matched        = Color(0xFF00E676); // Neon green ✓
  static const Color flipped        = Color(0xFF64B5F6); // Sky blue (face-up)
  static const Color textPrimary    = Color(0xFFF5F5F5);
  static const Color textSecondary  = Color(0xFFB0B0C8);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D0D1A), Color(0xFF1A0533)],
  );

  static const LinearGradient cardFrontGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
  );

  static const LinearGradient cardMatchedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF064E3B), Color(0xFF065F46)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
  );

  // ── Typography ────────────────────────────────────────────────────────────
  static TextTheme get textTheme => GoogleFonts.spaceGroteskTextTheme().copyWith(
        displayLarge: GoogleFonts.orbitron(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.orbitron(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(color: textPrimary),
        bodyMedium: GoogleFonts.spaceGrotesk(color: textSecondary),
        labelLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      );

  // ── MaterialApp Theme ─────────────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          background: background,
          surface: surface,
          primary: accent,
          secondary: accentLight,
          onPrimary: Colors.white,
          onSurface: textPrimary,
        ),
        scaffoldBackgroundColor: background,
        textTheme: textTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: accent.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            textStyle: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
}
