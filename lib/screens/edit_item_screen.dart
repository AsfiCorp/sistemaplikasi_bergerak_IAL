import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';

class EditItemScreen extends StatefulWidget {
  final ClothingItem item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _brand;
  late String _category;
  late String _material;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _title = widget.item.title;
    _brand = widget.item.brand;
    _category = ['Tops', 'Bottoms', 'Outerwear', 'Shoes', 'Accessories'].contains(widget.item.category) 
        ? widget.item.category 
        : 'Tops';
    _material = ['Cotton', 'Denim', 'Leather', 'Silk', 'Linen', 'Wool', 'Polyester', 'Corduroy', 'Flannel', 'Nylon', 'Velvet', 'Knit', 'Tweed', 'Viscose', 'Unknown'].contains(widget.item.material)
        ? widget.item.material 
        : 'Unknown';
    _imageBytes = widget.item.imageBytes;
  }

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

  void _updateItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final updatedItem = ClothingItem(
        id: widget.item.id,
        title: _title,
        category: _category,
        brand: _brand,
        imageUrl: widget.item.imageUrl,
        imageBytes: _imageBytes,
        year: widget.item.year,
        material: _material,
        isCustom: true,
      );

      context.read<WardrobeProvider>().updateItem(updatedItem);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item successfully updated!'), backgroundColor: AppTheme.primaryOlive),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EDIT ITEM')),
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
                        : (widget.item.imageUrl.isNotEmpty && _imageBytes == null)
                            ? DecorationImage(image: NetworkImage(widget.item.imageUrl), fit: BoxFit.cover)
                            : null,
                  ),
                  child: (_imageBytes == null && widget.item.imageUrl.isEmpty)
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
                initialValue: _title,
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
                initialValue: _brand,
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
                  onPressed: _updateItem,
                  child: const Text('UPDATE ITEM'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
