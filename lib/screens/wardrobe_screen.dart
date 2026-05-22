import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/dummy_data.dart';
import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';
import 'add_item_screen.dart';
import 'edit_item_screen.dart';
import 'archive_detail_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  String _selectedCategory = 'All';

  void _showItemDetails(BuildContext context, ClothingItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(24.0),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: item.imageBytes != null
                            ? Image.memory(item.imageBytes!, width: 100, height: 100, fit: BoxFit.cover)
                            : Image.network(item.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.brand.toUpperCase(), style: GoogleFonts.epilogue(color: AppTheme.tertiaryMutedOlive, fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(item.title, style: GoogleFonts.epilogue(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.secondaryCharcoal)),
                            const SizedBox(height: 8),
                            Text(item.material, style: GoogleFonts.inter(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Consumer<WardrobeProvider>(
                      builder: (context, wardrobe, child) {
                        final isOwned = wardrobe.items.any((i) => i.id == item.id);
                        return ElevatedButton(
                          onPressed: isOwned ? null : () {
                            Navigator.pop(context);
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
                  const SizedBox(height: 16),
                  
                  Consumer<WardrobeProvider>(
                    builder: (context, wardrobe, child) {
                      final isLoved = wardrobe.isFavorite(item.id);
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            wardrobe.toggleFavorite(item);
                          },
                          icon: Icon(
                            isLoved ? Icons.favorite : Icons.favorite_border,
                            color: isLoved ? Colors.red : AppTheme.primaryOlive,
                          ),
                          label: Text(
                            isLoved ? 'LOVED' : 'LOVE IT',
                            style: GoogleFonts.epilogue(
                              color: AppTheme.primaryOlive,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.primaryOlive),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  Consumer<WardrobeProvider>(
                    builder: (context, wardrobe, child) {
                      final isOwned = wardrobe.items.any((i) => i.id == item.id);
                      if (!isOwned) return const SizedBox.shrink();
                      
                      return Column(
                        children: [
                          if (item.isCustom) ...[
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditItemScreen(item: item)));
                                },
                                icon: const Icon(Icons.edit, color: AppTheme.primaryOlive),
                                label: Text(
                                  'EDIT ITEM',
                                  style: GoogleFonts.epilogue(
                                    color: AppTheme.primaryOlive,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppTheme.primaryOlive),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          SizedBox(
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
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ArchiveDetailScreen(item: item)));
                    },
                    child: Text('View Full Details', style: GoogleFonts.inter(color: AppTheme.primaryOlive, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wardrobe = context.watch<WardrobeProvider>();
    final items = _selectedCategory == 'All' 
        ? wardrobe.items 
        : wardrobe.items.where((i) => i.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddItemScreen()));
        },
        backgroundColor: AppTheme.primaryOlive,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Outfit for Today',
              style: GoogleFonts.epilogue(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryCharcoal,
              ),
            ),
          ),
          if (wardrobe.dailyOutfits.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
                ),
                child: Text(
                  'No outfit planned for today.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: AppTheme.tertiaryMutedOlive),
                ),
              ),
            )
          else
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: wardrobe.dailyOutfits.length,
                itemBuilder: (context, index) {
                  final outfit = wardrobe.dailyOutfits[index];
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        outfit.label,
                                        style: GoogleFonts.epilogue(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.secondaryCharcoal,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      onPressed: () {
                                        wardrobe.deleteOutfit(outfit.id);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Outfit deleted', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: outfit.items.length,
                                    itemBuilder: (context, idx) {
                                      final item = outfit.items[idx];
                                      return Container(
                                        width: 140,
                                        margin: const EdgeInsets.only(right: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                                                  Text(item.category.toUpperCase(), style: GoogleFonts.epilogue(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryOlive)),
                                                  const SizedBox(height: 4),
                                                  Text(item.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.secondaryCharcoal), maxLines: 1, overflow: TextOverflow.ellipsis),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOlive,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                outfit.label,
                                style: GoogleFonts.epilogue(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${outfit.items.length} Items',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: outfit.items.take(3).toList().asMap().entries.map((entry) {
                              final idx = entry.key;
                              final item = entry.value;
                              return Positioned(
                                right: idx * 25.0,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.primaryOlive, width: 2),
                                    image: DecorationImage(
                                      image: item.imageBytes != null 
                                          ? MemoryImage(item.imageBytes!) as ImageProvider
                                          : NetworkImage(item.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ),
          const SizedBox(height: 16),
          // Tab Switcher
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: DummyData.categories.length,
              itemBuilder: (context, index) {
                final category = DummyData.categories[index];
                final isSelected = category == _selectedCategory;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(
                      category.toUpperCase(),
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: isSelected ? Colors.white : AppTheme.secondaryCharcoal.withOpacity(0.6),
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppTheme.primaryOlive,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : AppTheme.tertiaryMutedOlive.withOpacity(0.3),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                );
              },
            ),
          ),
          
          // Wardrobe Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => _showItemDetails(context, item),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.2)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
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
                                  color: AppTheme.tertiaryMutedOlive,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  color: AppTheme.secondaryCharcoal,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
