import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/theme.dart';

class AppIntegrationsScreen extends StatelessWidget {
  const AppIntegrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('APP INTEGRATIONS')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildIntegrationCard(context, 'Depop', 'Connect to sync vintage finds.', profile.depopConnected, (v) {
              context.read<UserProfileProvider>().updateIntegration('depop', v);
            }),
            const SizedBox(height: 16),
            _buildIntegrationCard(context, 'Grailed', 'Import your Grailed wardrobe.', profile.grailedConnected, (v) {
              context.read<UserProfileProvider>().updateIntegration('grailed', v);
            }),
            const SizedBox(height: 16),
            _buildIntegrationCard(context, 'Instagram', 'Share OOTDs directly to stories.', profile.instagramConnected, (v) {
              context.read<UserProfileProvider>().updateIntegration('instagram', v);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationCard(BuildContext context, String title, String subtitle, bool isConnected, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.tertiaryMutedOlive.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.extension, color: AppTheme.primaryOlive),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.epilogue(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryCharcoal.withOpacity(0.6))),
              ],
            ),
          ),
          Switch(value: isConnected, onChanged: onChanged, activeColor: AppTheme.primaryOlive),
        ],
      ),
    );
  }
}
