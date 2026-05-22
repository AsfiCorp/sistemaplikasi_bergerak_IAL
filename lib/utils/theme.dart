import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Heritage Raw Palette (Google Stitch)
  static const Color primaryOlive = Color(0xFF556B2F); // Olive Green
  static const Color secondaryCharcoal = Color(0xFF333333); // Dark Gray
  static const Color tertiaryMutedOlive = Color(0xFFA9A970); // Muted Olive
  static const Color backgroundCream = Color(0xFFEBEBD0); // Washed Cream

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryOlive,
      scaffoldBackgroundColor: backgroundCream,
      colorScheme: const ColorScheme.light(
        primary: primaryOlive,
        secondary: tertiaryMutedOlive,
        surface: backgroundCream,
        onSurface: secondaryCharcoal,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundCream,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryOlive),
        titleTextStyle: GoogleFonts.epilogue(
          color: secondaryCharcoal,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.epilogue(
          color: secondaryCharcoal,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.epilogue(
          color: secondaryCharcoal,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: secondaryCharcoal,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: secondaryCharcoal,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundCream,
        selectedItemColor: primaryOlive,
        unselectedItemColor: tertiaryMutedOlive,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOlive,
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
