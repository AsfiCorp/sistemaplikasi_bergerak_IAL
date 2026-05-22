import 'package:ial_vintage_planner/services/ai_service.dart';
import 'package:ial_vintage_planner/models/clothing_item.dart';

void main() async {
  print('Running AI Service Test...');
  final service = AiService();
  try {
    final result = await service.generateOutfitIds('I want a cool vintage look for a sunny day in Bandung.', [
      ClothingItem(id: '1', title: 'Vintage Shirt', category: 'Tops', imageUrl: '', brand: 'Brand', year: '1990', material: 'Cotton'),
      ClothingItem(id: '2', title: 'Vintage Jeans', category: 'Bottoms', imageUrl: '', brand: 'Levi', year: '1980', material: 'Denim'),
    ]);
    print('Result: \$result');
  } catch (e) {
    print('Caught Exception: \$e');
  }
}
