import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/clothing_item.dart';
import '../models/dummy_data.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';

class InspirationDetailScreen extends StatefulWidget {
  final String imageUrl;

  const InspirationDetailScreen({super.key, required this.imageUrl});

  @override
  State<InspirationDetailScreen> createState() => _InspirationDetailScreenState();
}

class _InspirationDetailScreenState extends State<InspirationDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  
  static const List<String> _materialsList = ['Cotton', 'Denim', 'Leather', 'Polyester', 'Wool', 'Silk'];
  
  String _title = '';
  String _category = DummyData.categories[1]; // Default to Tops
  String _brand = '';
  String _year = '2020s';
  String _material = _materialsList[0]; // Default to Cotton

  void _saveToWardrobe() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final newItem = ClothingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        category: _category,
        brand: _brand,
        imageUrl: widget.imageUrl,
        year: _year,
        material: _material,
        isCustom: true,
      );

      context.read<WardrobeProvider>().addItem(newItem);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item successfully added to your Wardrobe!'),
          backgroundColor: AppTheme.primaryOlive,
        ),
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.secondaryCharcoal),
        title: Text(
          'Inspiration Details',
          style: GoogleFonts.epilogue(
            color: AppTheme.secondaryCharcoal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Preview
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Form Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Save to Wardrobe',
                      style: GoogleFonts.epilogue(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryCharcoal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fill in the details below to add this inspiration to your personal collection.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.tertiaryMutedOlive,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    _buildTextField(
                      label: 'Title / Note',
                      hint: 'e.g. Dreamy 90s Leather Jacket',
                      onSaved: (val) => _title = val ?? '',
                    ),
                    const SizedBox(height: 16),
                    
                    _buildDropdownField(
                      label: 'Category',
                      value: _category,
                      items: DummyData.categories.where((c) => c != 'All').toList(),
                      onChanged: (val) => setState(() => _category = val!),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Brand',
                      hint: 'e.g. Levi\'s',
                      onSaved: (val) => _brand = val ?? '',
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Era / Year',
                      hint: 'e.g. 1990s',
                      onSaved: (val) => _year = val ?? '',
                    ),
                    const SizedBox(height: 16),
                    
                    _buildDropdownField(
                      label: 'Material',
                      value: _material,
                      items: _materialsList,
                      onChanged: (val) => setState(() => _material = val!),
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveToWardrobe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryOlive,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add to Wardrobe',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required void Function(String?) onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.secondaryCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          onSaved: onSaved,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.secondaryCharcoal,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: GoogleFonts.inter()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
