import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import '../screens/privacy_center_screen.dart';
import '../screens/app_integrations_screen.dart';
import '../screens/help_support_screen.dart';
import '../screens/auth_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.primaryOlive,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'IAL',
                style: GoogleFonts.epilogue(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildMenuItem(context, 'HOME', Icons.home_outlined, () => Navigator.pop(context)),
            _buildMenuItem(context, 'APP INTEGRATIONS', Icons.extension_outlined, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AppIntegrationsScreen()));
            }),
            _buildMenuItem(context, 'DATA & PRIVACY', Icons.shield_outlined, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyCenterScreen()));
            }),
            _buildMenuItem(context, 'HELP & SUPPORT', Icons.help_outline, () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
            }),
            
            const Spacer(),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Log Out', style: GoogleFonts.epilogue(fontWeight: FontWeight.bold, color: AppTheme.secondaryCharcoal)),
                      content: Text('Are you sure you want to log out?', style: GoogleFonts.inter(color: AppTheme.secondaryCharcoal)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthProvider>().signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const AuthScreen()),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Yes, Log Out'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'LOGOUT',
                  style: GoogleFonts.epilogue(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
              child: Text(
                'v1.0.0 Heritage',
                style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.epilogue(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      onTap: onTap,
    );
  }
}
