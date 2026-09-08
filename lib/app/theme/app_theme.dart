import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const backgroundColor = Color(0xFFF7F4EC);
  static const surfaceColor = Color(0xFFFFFFFF);
  static const primaryColor = Color(0xFF1F2E35);
  static const textPrimaryColor = Color(0xFF1F2937);
  static const textSecondaryColor = Color(0xFF6B7280);
  static const accentGold = Color(0xFFE8B93F);
  static const accentBlue = Color(0xFF3B82F6);
  static const accentGreen = Color(0xFF5B8C5A);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      surface: surfaceColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
  );
}
