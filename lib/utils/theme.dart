import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Aesthetic White & Brown Palette
  static const Color primaryBrown = Color(0xFF8B5A2B); // Aesthetic Brown
  static const Color textDarkBrown = Color(0xFF3E2723); // Dark Brown
  static const Color tertiaryMutedBrown = Color(0xFFD7CCC8); // Muted Brown
  static const Color backgroundWhite = Colors.white; // White

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBrown,
      scaffoldBackgroundColor: backgroundWhite,
      colorScheme: const ColorScheme.light(
        primary: primaryBrown,
        secondary: tertiaryMutedBrown,
        surface: backgroundWhite,
        onSurface: textDarkBrown,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBrown),
        titleTextStyle: GoogleFonts.epilogue(
          color: textDarkBrown,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.epilogue(
          color: textDarkBrown,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.epilogue(
          color: textDarkBrown,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textDarkBrown,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textDarkBrown,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundWhite,
        selectedItemColor: primaryBrown,
        unselectedItemColor: tertiaryMutedBrown,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBrown,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.epilogue(fontWeight: FontWeight.w600, letterSpacing: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
    );
  }
}
