import 'dart:typed_data';
import 'dart:convert';

class ClothingItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final Uint8List? imageBytes;
  final String brand;
  final String year;
  final String material;
  final bool isCustom;

  ClothingItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    this.imageBytes,
    required this.brand,
    required this.year,
    required this.material,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'imageBytes': imageBytes != null ? base64Encode(imageBytes!) : null,
      'brand': brand,
      'year': year,
      'material': material,
      'isCustom': isCustom,
    };
  }

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      imageBytes: json['imageBytes'] != null ? base64Decode(json['imageBytes']) : null,
      brand: json['brand'],
      year: json['year'],
      material: json['material'],
      isCustom: json['isCustom'] ?? false,
    );
  }
}
