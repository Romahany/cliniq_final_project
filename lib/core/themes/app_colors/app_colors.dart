import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary Palette
  static const MaterialColor primary = MaterialColor(0xFF0284C7, <int, Color>{
    50: Color(0xFFE0F2FE),
    100: Color(0xFFBAE6FD),
    200: Color(0xFF7DD3FC),
    300: Color(0xFF38BDF8),
    400: Color(0xFF38BDF8),
    500: Color(0xFF0284C7),
    600: Color(0xFF0284C7),
    700: Color(0xFF0369A1),
    800: Color(0xFF075985),
    900: Color(0xFF0C4A6E),
  });

  static const Color primaryToken = Color(0xFF2F80ED);

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
  static const Color border = Color(0xFFE2E8F0); // Structure Edge
  static const Color divider = Color(0xFFE2E8F0); // Structure Edge

  // Feedback Tokens
  static const MaterialColor error = MaterialColor(0xFFDC2626, <int, Color>{
    50: Color(0xFFFEF2F2),
    100: Color(0xFFFEE2E2),
    200: Color(0xFFFECACA),
    300: Color(0xFFFCA5A5),
    400: Color(0xFFF87171),
    500: Color(0xFFDC2626),
    600: Color(0xFFDC5A5A),
    700: Color(0xFFB91C1C),
    800: Color(0xFF991B1B),
    900: Color(0xFF7F1D1D),
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
  static const Color accent = Color(0xFFFF4D6D);

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

  static const Color secondary = Color(0xFF2F80ED);
  static const Color shadow = Color(0x1A0C1015);

  // Utility Values
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
}
