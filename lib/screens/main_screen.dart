import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/wardrobe_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/custom_drawer.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'wardrobe_screen.dart';
import 'profile_screen.dart';
import '../utils/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _homeScrollController = ScrollController();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.currentUserEmail != null) {
        context.read<UserProfileProvider>().loadUserProfile(auth.currentUserEmail!, auth.currentUsername ?? '@user');
        context.read<WardrobeProvider>().loadUserWardrobe(auth.currentUserEmail!);
      }
    });
    _screens = [
      HomeScreen(scrollController: _homeScrollController),
      const SearchScreen(),
      const WardrobeScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _homeScrollController.dispose();
    super.dispose();
  }

  final List<String> _titles = [
    'IAL',
    'Discover',
    'My Wardrobe',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            if (navProvider.currentIndex == 0 && _homeScrollController.hasClients) {
              _homeScrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            }
          },
          child: Text(
            _titles[navProvider.currentIndex].toUpperCase(),
            style: GoogleFonts.epilogue(
              letterSpacing: 2.0,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: _screens[navProvider.currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppTheme.tertiaryMutedOlive.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navProvider.currentIndex,
          onTap: (index) {
            navProvider.setIndex(index);
          },
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.epilogue(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.epilogue(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home)),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.search_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.search)),
              label: 'SEARCH',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.checkroom_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.checkroom)),
              label: 'WARDROBE',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_outline)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person)),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
