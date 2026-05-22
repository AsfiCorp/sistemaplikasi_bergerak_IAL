import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart';

class PrivacyCenterScreen extends StatelessWidget {
  const PrivacyCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DATA & PRIVACY'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 120,
                color: AppTheme.primaryOlive,
              ),
              const SizedBox(height: 32),
              Text(
                '100% LOCAL PROCESSING',
                textAlign: TextAlign.center,
                style: GoogleFonts.epilogue(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.secondaryCharcoal,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your wardrobe data and preferences never leave your device. We believe in complete privacy for your personal style archive.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.secondaryCharcoal.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: AppTheme.primaryOlive),
                label: Text(
                  'BACK TO APP',
                  style: GoogleFonts.epilogue(
                    color: AppTheme.primaryOlive,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryOlive),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
