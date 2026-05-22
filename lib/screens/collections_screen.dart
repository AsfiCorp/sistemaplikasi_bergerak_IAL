import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';
import 'archive_detail_screen.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wardrobe = context.watch<WardrobeProvider>();
    final items = wardrobe.items;

    return Scaffold(
      appBar: AppBar(title: const Text('MY COLLECTIONS')),
      body: items.isEmpty
          ? Center(
              child: Text(
                'No collections yet',
                style: GoogleFonts.epilogue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tertiaryMutedOlive,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ArchiveDetailScreen(item: item)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: item.imageBytes != null 
                            ? MemoryImage(item.imageBytes!) as ImageProvider 
                            : NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(0.4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.category.toUpperCase(),
                        style: GoogleFonts.epilogue(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
