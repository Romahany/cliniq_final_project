import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary Palette (#2F88ED)
  static const MaterialColor primary = MaterialColor(0xFF2F88ED, <int, Color>{
    50: Color(0xFFEAF4FF),
    100: Color(0xFFD6E8FF),
    200: Color(0xFFB5D5FF),
    300: Color(0xFF8BBBFF),
    400: Color(0xFF5BA2FF),
    500: Color(0xFF2F88ED),
    600: Color(0xFF1D6ED4),
    700: Color(0xFF1556AC),
    800: Color(0xFF14478B),
    900: Color(0xFF153C6F),
  });

  static const Color primaryToken = Color(0xFF2F88ED);
  static const Color lightBlue = Color(0xFFEAF4FF); // Chips, active panels

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC); // Canvas Tint
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceLowest = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF172B4D);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color darkNavy = Color(0xFF16324F);
  static const Color black = Color(0xFF0C1015);

  // Structural Colors
  static const Color border = Color(0xFFE2EBF0); // Structure Edge
  static const Color divider = Color(0xFFE2EBF0); // Structure Edge

  // Feedback Tokens
  static const MaterialColor error = MaterialColor(0xFFDC5A5A, <int, Color>{
    50: Color(0xFFFDF2F2),
    100: Color(0xFFFDE4E4),
    200: Color(0xFFFBCACA),
    300: Color(0xFFF7A2A2),
    400: Color(0xFFF07979),
    500: Color(0xFFDC5A5A),
    600: Color(0xFFC83F3F),
    700: Color(0xFFA62E2E),
    800: Color(0xFF8A2A2A),
    900: Color(0xFF732828),
  });

  static const Color errorVariant = Color(0xFFDC5A5A);

  static const MaterialColor success = MaterialColor(0xFF22A06B, <int, Color>{
    50: Color(0xFFE6F7F0),
    100: Color(0xFFC3EFE0),
    200: Color(0xFF97E3CA),
    300: Color(0xFF62D4B0),
    400: Color(0xFF37C297),
    500: Color(0xFF22A06B),
    600: Color(0xFF1B8558),
    700: Color(0xFF166B47),
    800: Color(0xFF125338),
    900: Color(0xFF0D3D2A),
  });

  static const Color warning = Color(0xFFF59E0B);
  static const Color accent = Color(0xFFFF4D6D); // Heart Accent

  // Legacy compatibility helpers
  static const MaterialColor grey = MaterialColor(0xFF64748B, <int, Color>{
    50: Color(0xFFF8FAFC),
    100: Color(0xFFF1F5F9),
    200: Color(0xFFE2E8F0),
    300: Color(0xFFCBD5E1),
    400: Color(0xFF94A3B8),
    500: Color(0xFF64748B),
    600: Color(0xFF475569),
    700: Color(0xFF334155),
    800: Color(0xFF1E293B),
    900: Color(0xFF0F172A),
  });

  static const Color secondary = Color(0xFF2F88ED);
  static const Color shadow = Color(0x1A0C1015);

  // Utility Values
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
}
