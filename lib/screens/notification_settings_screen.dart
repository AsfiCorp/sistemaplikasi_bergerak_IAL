import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  late bool pushEnabled;
  late bool emailEnabled;
  late bool newArrivals;
  late bool styleTips;

  @override
  void initState() {
    super.initState();
    final profile = context.read<UserProfileProvider>();
    pushEnabled = profile.pushEnabled;
    emailEnabled = profile.emailEnabled;
    newArrivals = profile.newArrivals;
    styleTips = profile.styleTips;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<UserProfileProvider>().updateNotificationSettings(
          pushEnabled, emailEnabled, newArrivals, styleTips
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('NOTIFICATIONS')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text('Global Settings', style: GoogleFonts.epilogue(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryOlive)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text('Push Notifications', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            value: pushEnabled,
            activeColor: AppTheme.primaryOlive,
            onChanged: (val) => setState(() => pushEnabled = val),
          ),
          SwitchListTile(
            title: Text('Email Notifications', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            value: emailEnabled,
            activeColor: AppTheme.primaryOlive,
            onChanged: (val) => setState(() => emailEnabled = val),
          ),
          const SizedBox(height: 32),
          Text('Content', style: GoogleFonts.epilogue(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryOlive)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text('New Archives & Arrivals', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            value: newArrivals,
            activeColor: AppTheme.primaryOlive,
            onChanged: (val) => setState(() => newArrivals = val),
          ),
          SwitchListTile(
            title: Text('Weekly Style Tips', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            value: styleTips,
            activeColor: AppTheme.primaryOlive,
            onChanged: (val) => setState(() => styleTips = val),
          ),
        ],
      ),
    ),
    );
  }
}
