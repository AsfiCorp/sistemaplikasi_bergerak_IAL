import 'clothing_item.dart';

class DummyData {
  static List<ClothingItem> wardrobeItems = [
    ClothingItem(
      id: '1',
      title: 'Vintage Leather Jacket',
      category: 'Outerwear',
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      brand: 'Schott NYC',
      year: '1980s',
      material: 'Genuine Leather',
    ),
    ClothingItem(
      id: '2',
      title: "Levi's 501 Original",
      category: 'Bottoms',
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      brand: "Levi's",
      year: '1995',
      material: '100% Cotton Denim',
    ),
    ClothingItem(
      id: '3',
      title: 'Olive Cargo Pants',
      category: 'Bottoms',
      imageUrl: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      brand: 'Military Surplus',
      year: '1970s',
      material: 'Cotton Canvas',
    ),
    ClothingItem(
      id: '4',
      title: 'Wool Trench Coat',
      category: 'Outerwear',
      imageUrl: 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      brand: 'Burberry',
      year: '1990s',
      material: '100% Wool',
    ),
    ClothingItem(
      id: '5',
      title: 'Graphic Band Tee',
      category: 'Tops',
      imageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      brand: 'Vintage',
      year: '1988',
      material: 'Cotton',
    ),
    ClothingItem(
      id: '6',
      title: 'Chunky Knit Sweater',
      category: 'Tops',
      imageUrl: 'https://images.unsplash.com/photo-1614830188981-d1421bdf50ed?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      brand: 'L.L.Bean',
      year: '1992',
      material: 'Wool Blend',
    ),
  ];

  static List<String> categories = [
    'All',
    'Tops',
    'Bottoms',
    'Outerwear',
    'Accessories',
  ];
}
