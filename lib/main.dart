import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/user_profile_provider.dart';
import 'providers/wardrobe_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => WardrobeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const IALVintageApp(),
    ),
  );
}

class IALVintageApp extends StatelessWidget {
  const IALVintageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IAL Vintage Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (!auth.isInitialized) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryOlive),
              ),
            );
          }
          if (auth.isLoggedIn) {
            return MainScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
