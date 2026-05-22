import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/theme.dart';

class LocationModal extends StatefulWidget {
  const LocationModal({super.key});

  @override
  State<LocationModal> createState() => _LocationModalState();
}

class _LocationModalState extends State<LocationModal> {
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<UserProfileProvider>();
    _locationController = TextEditingController(text: profile.userLocation);
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SET YOUR LOCATION',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryCharcoal,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'CITY NAME',
                hintStyle: GoogleFonts.epilogue(color: Colors.grey.shade400, letterSpacing: 1.0),
                filled: true,
                fillColor: AppTheme.backgroundCream.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.tertiaryMutedOlive.withOpacity(0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.tertiaryMutedOlive.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryOlive),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.my_location, color: AppTheme.primaryOlive),
                label: Text(
                  'USE CURRENT LOCATION',
                  style: GoogleFonts.epilogue(
                    color: AppTheme.primaryOlive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryOlive),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserProfileProvider>().updateLocation(_locationController.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOlive,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
