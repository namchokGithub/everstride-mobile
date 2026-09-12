import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const jade = Color(0xFF2E9B5F);
  static const mint = Color(0xFFA9F1C9);
  static const deepNavy = Color(0xFF16233D);
  static const warmCream = Color(0xFFFBF6EC);
  static const amber = Color(0xFFE8B93F);
  static const berry = Color(0xFFC65D5D);

  static const backgroundColor = warmCream;
  static const surfaceColor = Color(0xFFFFFFFF);
  static const textPrimaryColor = deepNavy;
  static const textSecondaryColor = Color(0xFF5B6B7A);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: jade,
      brightness: Brightness.light,
      surface: surfaceColor,
      error: berry,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: deepNavy,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: deepNavy,
    colorScheme: ColorScheme.fromSeed(
      seedColor: jade,
      brightness: Brightness.dark,
      surface: const Color(0xFF20314F),
      error: berry,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: deepNavy,
      foregroundColor: warmCream,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: jade,
        foregroundColor: deepNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
}
