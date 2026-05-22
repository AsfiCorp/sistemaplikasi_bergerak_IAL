import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/theme.dart';

class StylePreferencesScreen extends StatefulWidget {
  const StylePreferencesScreen({super.key});

  @override
  State<StylePreferencesScreen> createState() => _StylePreferencesScreenState();
}

class _StylePreferencesScreenState extends State<StylePreferencesScreen> {
  late bool strictVintageMode;
  late bool allowModernMix;
  late bool earthTonesPriority;
  late String selectedFit;

  @override
  void initState() {
    super.initState();
    final profile = context.read<UserProfileProvider>();
    strictVintageMode = profile.strictVintageMode;
    allowModernMix = profile.allowModernMix;
    earthTonesPriority = profile.earthTonesPriority;
    selectedFit = profile.selectedFit;
  }

  void _savePreferences() {
    context.read<UserProfileProvider>().updateStylePreferences(
      strictVintageMode, allowModernMix, earthTonesPriority, selectedFit
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STYLE PREFERENCES'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generation Rules',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryOlive,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSwitchTile('Strict Vintage Mode', 'Only use items before 2000s', strictVintageMode, (val) {
              setState(() => strictVintageMode = val);
            }),
            _buildSwitchTile('Allow Modern Mix', 'Mix vintage with modern basics', allowModernMix, (val) {
              setState(() => allowModernMix = val);
            }),
            _buildSwitchTile('Earth Tones Priority', 'Prefer olive, brown, and cream palettes', earthTonesPriority, (val) {
              setState(() => earthTonesPriority = val);
            }),
            
            const SizedBox(height: 40),
            
            Text(
              'Fit Preferences',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryOlive,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFitOption('Oversized', true),
            _buildFitOption('Relaxed / Straight', true),
            _buildFitOption('Slim / Skinny', false), // Disabled option
            
            const SizedBox(height: 48),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePreferences,
                child: const Text('SAVE PREFERENCES'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: GoogleFonts.epilogue(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryOlive,
      ),
    );
  }

  Widget _buildFitOption(String title, bool isAvailable) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isAvailable ? (selectedFit == title ? AppTheme.primaryOlive.withOpacity(0.1) : Colors.white) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable && selectedFit == title 
              ? AppTheme.primaryOlive 
              : AppTheme.tertiaryMutedOlive.withOpacity(0.3),
        ),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            decoration: isAvailable ? null : TextDecoration.lineThrough,
            color: isAvailable ? AppTheme.secondaryCharcoal : Colors.grey.shade500,
          ),
        ),
        value: title,
        groupValue: selectedFit,
        onChanged: isAvailable ? (val) {
          if (val != null) setState(() => selectedFit = val);
        } : null,
        activeColor: AppTheme.primaryOlive,
      ),
    );
  }
}
