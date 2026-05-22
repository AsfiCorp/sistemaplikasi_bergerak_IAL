import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';
import 'style_preferences_screen.dart';
import 'edit_profile_screen.dart';
import 'collections_screen.dart';
import 'favorites_screen.dart';
import 'notification_settings_screen.dart';
import 'auth_screen.dart';
import 'privacy_center_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfileProvider>();
    final wardrobe = context.watch<WardrobeProvider>();
    final auth = context.watch<AuthProvider>();
    
    final joinDateStr = auth.joinDate ?? DateTime.now().toIso8601String();
    final formattedJoinDate = DateFormat('MMMM yyyy').format(DateTime.parse(joinDateStr));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Consumer<UserProfileProvider>(
            builder: (context, profile, child) {
              return CircleAvatar(
                radius: 60,
                backgroundImage: profile.profileImageBytes != null
                    ? MemoryImage(profile.profileImageBytes!) as ImageProvider
                    : const NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            auth.currentName ?? 'User',
            style: GoogleFonts.epilogue(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryCharcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userProfile.username,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.tertiaryMutedOlive,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Member since $formattedJoinDate',
            style: GoogleFonts.inter(
              color: AppTheme.tertiaryMutedOlive,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              userProfile.bio,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.secondaryCharcoal.withOpacity(0.8),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn(wardrobe.items.length.toString(), 'Collections', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CollectionsScreen()));
                }),
                Container(width: 1, height: 40, color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
                _buildStatColumn(wardrobe.favoriteItems.length.toString(), 'Favorites', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
                }),
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          
          _buildMenuRow(context, Icons.edit_outlined, 'Edit Profile', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
          }),
          const Divider(height: 32),
          _buildMenuRow(context, Icons.notifications_outlined, 'Notifications', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
          }),
          const Divider(height: 32),
          _buildMenuRow(context, Icons.lock_outline, 'Privacy & Security', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyCenterScreen()));
          }),
          const Divider(height: 32),
          _buildMenuRow(context, Icons.logout, 'Log Out', () {
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
                      context.read<UserProfileProvider>().clearProfileState();
                      context.read<WardrobeProvider>().clearLocalState();
                      auth.signOut();
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
          }, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.epilogue(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryOlive,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.secondaryCharcoal.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
        Icon(icon, color: color ?? AppTheme.secondaryCharcoal),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: color ?? AppTheme.secondaryCharcoal,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Icon(Icons.chevron_right, color: AppTheme.tertiaryMutedOlive),
      ],
      ),
    );
  }
}
