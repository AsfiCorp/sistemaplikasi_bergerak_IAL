import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _brand = '';
  String _category = 'Tops';
  String _material = 'Cotton';
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final newItem = ClothingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        category: _category,
        brand: _brand,
        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Fallback
        imageBytes: _imageBytes,
        year: 'Unknown',
        material: _material,
        isCustom: true,
      );

      context.read<WardrobeProvider>().addItem(newItem);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to Wardrobe!'), backgroundColor: AppTheme.primaryOlive),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADD NEW ITEM')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.tertiaryMutedOlive.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3), style: BorderStyle.solid),
                    image: _imageBytes != null
                        ? DecorationImage(image: MemoryImage(_imageBytes!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _imageBytes == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_outlined, size: 48, color: AppTheme.primaryOlive),
                            const SizedBox(height: 8),
                            Text('Upload Image', style: GoogleFonts.inter(color: AppTheme.primaryOlive, fontWeight: FontWeight.bold)),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 32),
              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Item Title',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Brand',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a brand' : null,
                onSaved: (value) => _brand = value!,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                items: ['Tops', 'Bottoms', 'Outerwear', 'Shoes', 'Accessories']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _material,
                decoration: InputDecoration(
                  labelText: 'Material',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                items: ['Cotton', 'Denim', 'Leather', 'Silk', 'Linen', 'Wool', 'Polyester', 'Corduroy', 'Flannel', 'Nylon', 'Velvet', 'Knit', 'Tweed', 'Viscose', 'Unknown']
                    .map((mat) => DropdownMenuItem(value: mat, child: Text(mat)))
                    .toList(),
                onChanged: (value) => setState(() => _material = value!),
              ),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveItem,
                  child: const Text('SAVE ITEM'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
