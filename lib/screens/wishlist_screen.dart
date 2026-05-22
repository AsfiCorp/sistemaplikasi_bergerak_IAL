import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dummy_data.dart';
import '../utils/theme.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WISHLIST')),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: DummyData.wardrobeItems.length,
        itemBuilder: (context, index) {
          final item = DummyData.wardrobeItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
              ),
              title: Text(item.title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              subtitle: Text(item.brand, style: GoogleFonts.inter(color: AppTheme.tertiaryMutedOlive)),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: AppTheme.primaryOlive),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
