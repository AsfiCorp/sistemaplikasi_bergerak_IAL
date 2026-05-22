import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/clothing_item.dart';
import '../models/outfit.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';

class OotdResultScreen extends StatefulWidget {
  final List<ClothingItem> generatedItems;
  final String promptLabel;

  const OotdResultScreen({super.key, required this.generatedItems, required this.promptLabel});

  @override
  State<OotdResultScreen> createState() => _OotdResultScreenState();
}

class _OotdResultScreenState extends State<OotdResultScreen> {
  void _saveOutfit() {
    final label = widget.promptLabel;
    
    final outfit = Outfit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(widget.generatedItems),
      label: label,
      createdAt: DateTime.now(),
    );
    
    context.read<WardrobeProvider>().addOutfit(outfit);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI Outfit saved to Wardrobe!'), backgroundColor: AppTheme.primaryOlive),
    );
    
    Navigator.pop(context); // Go back to Home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      appBar: AppBar(title: const Text('AI GENERATED OOTD')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Here is what the AI curated for you:',
                style: GoogleFonts.epilogue(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryCharcoal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: widget.generatedItems.length,
              itemBuilder: (context, index) {
                final item = widget.generatedItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          image: DecorationImage(
                            image: item.imageBytes != null 
                                ? MemoryImage(item.imageBytes!) as ImageProvider 
                                : NetworkImage(item.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.category.toUpperCase(),
                                style: GoogleFonts.epilogue(
                                  color: AppTheme.primaryOlive,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.secondaryCharcoal,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.material}',
                                style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'Prompt Label: ${widget.promptLabel}',
                    style: GoogleFonts.inter(
                      fontStyle: FontStyle.italic,
                      color: AppTheme.secondaryCharcoal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveOutfit,
                      child: const Text('SAVE OUTFIT TO WARDROBE'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
