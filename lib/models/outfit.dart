import 'clothing_item.dart';

class Outfit {
  final String id;
  final List<ClothingItem> items;
  final String label;
  final DateTime createdAt;

  Outfit({
    required this.id,
    required this.items,
    required this.label,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'label': label,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'],
      items: (json['items'] as List).map((i) => ClothingItem.fromJson(i)).toList(),
      label: json['label'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
