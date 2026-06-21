import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Teal Tones
  static const Color primaryLight = Color(0xFF0D9488); // Teal 600
  static const Color primaryDark = Color(0xFF2DD4BF);  // Teal 400
  
  // Slate Background Tones
  static const Color bgLight = Color(0xFFF8FAFC);      // Slate 50
  static const Color bgDark = Color(0xFF0F172A);       // Slate 900
  
  // Surface Card Tones
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);  // Slate 800
  
  // Border Slate Tones
  static const Color borderLight = Color(0xFFE2E8F0);   // Slate 200
  static const Color borderDark = Color(0xFF334155);    // Slate 700
  
  // Text Slate Tones
  static const Color textLight = Color(0xFF0F172A);
  static const Color textDark = Color(0xFFF8FAFC);
  
  // Status Colors
  static const Color success = Color(0xFF0D9488);       // Teal
  static const Color warning = Color(0xFFF59E0B);       // Amber
  static const Color error = Color(0xFFEF4444);         // Red
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.bgLight,
      fontFamily: GoogleFonts.kantumruyPro().fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.primaryLight,
        surface: AppColors.bgLight,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.textLight),
        titleTextStyle: TextStyle(
          color: AppColors.textLight,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.borderLight.withOpacity(0.8),
            width: 1.2,
          ),
        ),
        color: AppColors.surfaceLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.bgDark,
      fontFamily: GoogleFonts.kantumruyPro().fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.primaryDark,
        surface: AppColors.bgDark,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.bgDark,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: AppColors.borderDark,
            width: 1.2,
          ),
        ),
        color: AppColors.surfaceDark,
      ),
    );
  }
}
