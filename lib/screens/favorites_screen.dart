import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';
import '../models/clothing_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<WardrobeProvider>().favoriteItems;
    
    return Scaffold(
      appBar: AppBar(title: const Text('FAVORITES')),
      body: favorites.isEmpty 
        ? Center(child: Text('No favorites yet.', style: GoogleFonts.inter(color: AppTheme.tertiaryMutedOlive)))
        : ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final item = favorites[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.imageBytes != null 
                    ? Image.memory(item.imageBytes!, width: 60, height: 60, fit: BoxFit.cover)
                    : Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
              ),
              title: Text(item.title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              subtitle: Text(item.brand, style: GoogleFonts.inter(color: AppTheme.tertiaryMutedOlive)),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: AppTheme.primaryOlive),
                onPressed: () {
                  context.read<WardrobeProvider>().toggleFavorite(item);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
