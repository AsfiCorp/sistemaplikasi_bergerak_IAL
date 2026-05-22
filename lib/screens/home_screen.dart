import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import '../widgets/location_modal.dart';
import '../providers/wardrobe_provider.dart';
import 'ootd_preference_screen.dart';
import 'wardrobe_screen.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController? scrollController;
  
  const HomeScreen({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfileProvider>();
    final wardrobe = context.watch<WardrobeProvider>();
    final auth = context.watch<AuthProvider>();

    String getGreeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) return 'Good Morning';
      if (hour < 18) return 'Good Afternoon';
      return 'Good Evening';
    }
    
    final name = auth.currentName ?? 'User';

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${getGreeting()}, $name',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppTheme.secondaryCharcoal.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ready to explore vintage?',
                      style: GoogleFonts.epilogue(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.secondaryCharcoal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  context.read<NavigationProvider>().setIndex(3);
                },
                child: Consumer<UserProfileProvider>(
                  builder: (context, profile, child) {
                    return CircleAvatar(
                      radius: 24,
                      backgroundImage: profile.profileImageBytes != null
                          ? MemoryImage(profile.profileImageBytes!) as ImageProvider
                          : const NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'),
                    );
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Weather Card
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const LocationModal(),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.tertiaryMutedOlive.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.primaryOlive),
                          const SizedBox(width: 4),
                          Text(
                            userProfile.userLocation.toUpperCase(),
                            style: GoogleFonts.epilogue(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 1.5,
                              color: AppTheme.primaryOlive,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cerah',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppTheme.secondaryCharcoal.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '28°C',
                    style: GoogleFonts.epilogue(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.secondaryCharcoal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final hasEnoughItems = wardrobe.items.length >= 3;
                final hasTops = wardrobe.items.any((i) => i.category == 'Tops');
                final hasBottoms = wardrobe.items.any((i) => i.category == 'Bottoms');
                
                if (!hasEnoughItems || !hasTops || !hasBottoms) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Wardrobe Needs More Items', style: GoogleFonts.epilogue(fontWeight: FontWeight.bold, color: AppTheme.secondaryCharcoal)),
                      content: Text(
                        'Please add at least 3 items to your wardrobe (including at least 1 Top and 1 Bottom) before the AI can generate an outfit.',
                        style: GoogleFonts.inter(color: AppTheme.secondaryCharcoal),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<NavigationProvider>().setIndex(1);
                          },
                          child: const Text('Go to Wardrobe'),
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OotdPreferenceScreen()),
                  );
                }
              },
              child: const Text('GENERATE MY OOTD'),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Recently Added
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Added',
                style: GoogleFonts.epilogue(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryCharcoal,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WardrobeScreen()));
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryOlive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Recently added list
          if (wardrobe.items.isEmpty)
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3), style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 48, color: AppTheme.tertiaryMutedOlive.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'Your wardrobe is empty.',
                    style: GoogleFonts.epilogue(color: AppTheme.secondaryCharcoal, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start adding items!',
                    style: GoogleFonts.inter(color: AppTheme.tertiaryMutedOlive),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: wardrobe.items.length > 5 ? 5 : wardrobe.items.length,
                itemBuilder: (context, index) {
                  final item = wardrobe.items[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              image: DecorationImage(
                                image: item.imageBytes != null 
                                    ? MemoryImage(item.imageBytes!) as ImageProvider 
                                    : NetworkImage(item.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.brand.toUpperCase(),
                                style: GoogleFonts.epilogue(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.tertiaryMutedOlive,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.secondaryCharcoal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
