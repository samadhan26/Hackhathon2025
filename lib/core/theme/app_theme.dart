import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF673AB7); // Deep Purple
  static const Color accentColor = Color(0xFFD1C4E9); // Light Purple
  static const Color textColor = Colors.black87;

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16),
        titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
    );
  }
}
