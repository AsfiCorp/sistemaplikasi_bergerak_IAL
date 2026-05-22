import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';
import 'edit_item_screen.dart';

class ArchiveDetailScreen extends StatelessWidget {
  final ClothingItem item;

  const ArchiveDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Consumer<WardrobeProvider>(
            builder: (context, wardrobe, child) {
              final isLoved = wardrobe.isFavorite(item.id);
              return IconButton(
                icon: Icon(
                  isLoved ? Icons.favorite : Icons.favorite_border,
                  color: isLoved ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  wardrobe.toggleFavorite(item);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: item.imageBytes != null 
                      ? MemoryImage(item.imageBytes!) as ImageProvider 
                      : NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                      AppTheme.backgroundCream.withOpacity(0.8),
                      AppTheme.backgroundCream,
                    ],
                    stops: const [0.0, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THE ESSENTIAL',
                    style: GoogleFonts.epilogue(
                      color: AppTheme.primaryOlive,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: GoogleFonts.epilogue(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.secondaryCharcoal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tags Row
                  Row(
                    children: [
                      _buildPill(item.brand.toUpperCase()),
                      const SizedBox(width: 8),
                      _buildPill(item.material, outlined: true),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Specs Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        _buildSpecRow('Category', item.category),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(height: 1),
                        ),
                        _buildSpecRow('Material', item.material),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<WardrobeProvider>(
                      builder: (context, wardrobe, child) {
                        final isOwned = wardrobe.items.any((i) => i.id == item.id);
                        return ElevatedButton(
                          onPressed: isOwned ? null : () {
                            wardrobe.addItem(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Item successfully added to your Wardrobe!',
                                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                                backgroundColor: AppTheme.primaryOlive,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isOwned ? Colors.grey.shade400 : AppTheme.primaryOlive,
                            disabledBackgroundColor: Colors.grey.shade400,
                          ),
                          child: Text(isOwned ? 'ALREADY IN WARDROBE' : 'ADD TO WARDROBE'),
                        );
                      },
                    ),
                  ),
                  Consumer<WardrobeProvider>(
                    builder: (context, wardrobe, child) {
                      final isOwned = wardrobe.items.any((i) => i.id == item.id);
                      if (!isOwned) return const SizedBox.shrink();
                      
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              wardrobe.deleteItem(item.id);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Item removed from your wardrobe',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                            label: Text(
                              'REMOVE FROM WARDROBE',
                              style: GoogleFonts.epilogue(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red.shade200),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: item.isCustom ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditItemScreen(item: item)));
        },
        backgroundColor: AppTheme.primaryOlive,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text('EDIT ITEM', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
      ) : null,
    );
  }

  Widget _buildPill(String text, {bool outlined = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : AppTheme.tertiaryMutedOlive.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: outlined ? Border.all(color: AppTheme.primaryOlive) : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: AppTheme.primaryOlive,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppTheme.secondaryCharcoal.withOpacity(0.6),
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            color: AppTheme.secondaryCharcoal,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
