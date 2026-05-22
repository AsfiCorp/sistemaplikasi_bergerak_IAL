import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../services/ai_service.dart';
import '../utils/theme.dart';
import 'ootd_result_screen.dart';

class OotdPreferenceScreen extends StatefulWidget {
  const OotdPreferenceScreen({super.key});

  @override
  State<OotdPreferenceScreen> createState() => _OotdPreferenceScreenState();
}

class _OotdPreferenceScreenState extends State<OotdPreferenceScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generateOutfit(BuildContext context) async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please tell the AI what you need!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final wardrobeProvider = context.read<WardrobeProvider>();
    final items = wardrobeProvider.items;

    try {
      final aiService = AiService();
      final List<String> generatedIds = await aiService.generateOutfitIds(prompt, items);
      
      if (generatedIds.isEmpty) {
        throw Exception('AI returned no items or failed to parse.');
      }

      // Map IDs back to ClothingItem objects
      List<ClothingItem> generatedItems = [];
      for (String id in generatedIds) {
        try {
          final item = items.firstWhere((element) => element.id == id);
          generatedItems.add(item);
        } catch (e) {
          // If ID from AI is not found in wardrobe, just ignore
          print('Item ID $id not found in wardrobe');
        }
      }

      if (generatedItems.isEmpty) {
         throw Exception('None of the AI generated IDs matched your wardrobe.');
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OotdResultScreen(generatedItems: generatedItems, promptLabel: prompt)),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate outfit: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCream,
      appBar: AppBar(title: const Text('AI PREFERENCES')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help the AI understand your vibe today.',
              style: GoogleFonts.epilogue(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryCharcoal,
              ),
            ),
            const SizedBox(height: 32),
            
            TextFormField(
              controller: _promptController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Tell the AI what you need',
                hintText: 'Contoh: Saya butuh outfit vintage untuk nongkrong di Braga malam ini dengan cuaca agak gerimis...',
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _generateOutfit(context),
                icon: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.auto_awesome),
                label: Text(_isLoading ? 'GENERATING...' : 'GENERATE AI OUTFIT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
