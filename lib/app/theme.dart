import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTheme {
  // Backgrounds
  static const Color background = Color(0xFF070B14);
  static const Color surface = Color(0xFF0D1320);
  static const Color surfaceLight = Color(0xFF111A2A);

  // Accent
  static const Color primary = Color(0xFF7C5CFF);
  static const Color primaryLight = Color(0xFF9A85FF);

  // Text
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFFA7AFBF);

  // Borders
  static const Color border = Color(0xFF1C2638);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: primary,

    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: surface,
    ),

  

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),textTheme: TextTheme(
  displayLarge: GoogleFonts.inter(
    color: textPrimary,
    fontSize: 64,
    fontWeight: FontWeight.w700,
    height: 1.05,
  ),
  displayMedium: GoogleFonts.inter(
    color: textPrimary,
    fontSize: 48,
    fontWeight: FontWeight.w700,
  ),
  headlineMedium: GoogleFonts.inter(
    color: textPrimary,
    fontSize: 36,
    fontWeight: FontWeight.w700,
  ),
  titleLarge: GoogleFonts.inter(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  ),
  bodyLarge: GoogleFonts.inter(
    color: textSecondary,
    fontSize: 18,
    height: 1.6,
  ),
  bodyMedium: GoogleFonts.inter(
    color: textSecondary,
    fontSize: 16,
    height: 1.5,
  ),
),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}