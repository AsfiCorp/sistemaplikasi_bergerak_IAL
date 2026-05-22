import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/clothing_item.dart';
import '../models/outfit.dart';
import '../models/dummy_data.dart';

class WardrobeProvider with ChangeNotifier {
  final List<ClothingItem> _items = [];
  final List<ClothingItem> _favorites = [];
  final List<dynamic> _collections = [];
  final List<ClothingItem> _currentOotd = [];
  final List<Outfit> _dailyOutfits = [];
  String? _currentUserEmail;

  WardrobeProvider() {
    // Initial load will be triggered by auth state
  }

  void clearLocalState() {
    _items.clear();
    _favorites.clear();
    _dailyOutfits.clear();
    _currentUserEmail = null;
    notifyListeners();
  }

  Future<void> loadUserWardrobe(String email) async {
    _currentUserEmail = email;
    await _loadFromPrefs();
  }

  List<dynamic> get collections => _collections;

  List<ClothingItem> get items => _items;

  List<ClothingItem> get currentOotd => _currentOotd;

  List<Outfit> get dailyOutfits => _dailyOutfits;

  List<ClothingItem> get favoriteItems => _favorites;

  bool isFavorite(String id) {
    return _favorites.any((item) => item.id == id);
  }

  Future<void> _saveToPrefs() async {
    if (_currentUserEmail == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    
    final itemsJson = _items.map((item) => item.toJson()).toList();
    await prefs.setString('wardrobe_items_$_currentUserEmail', jsonEncode(itemsJson));
    final favsJson = _favorites.map((item) => item.toJson()).toList();
    await prefs.setString('wardrobe_favorites_v2_$_currentUserEmail', jsonEncode(favsJson));
    final outfitsJson = _dailyOutfits.map((outfit) => outfit.toJson()).toList();
    await prefs.setString('daily_outfits_$_currentUserEmail', jsonEncode(outfitsJson));
  }

  Future<void> _loadFromPrefs() async {
    if (_currentUserEmail == null) return;
    
    final prefs = await SharedPreferences.getInstance();

    final itemsString = prefs.getString('wardrobe_items_$_currentUserEmail');
    
    if (itemsString != null) {
      final List<dynamic> decoded = jsonDecode(itemsString);
      _items.clear();
      _items.addAll(decoded.map((json) => ClothingItem.fromJson(json)).toList());
    }

    final favsString = prefs.getString('wardrobe_favorites_v2_$_currentUserEmail');
    if (favsString != null) {
      final List<dynamic> decodedFavs = jsonDecode(favsString);
      _favorites.clear();
      _favorites.addAll(decodedFavs.map((json) => ClothingItem.fromJson(json)).toList());
    }

    final outfitsString = prefs.getString('daily_outfits_$_currentUserEmail');
    if (outfitsString != null) {
      final List<dynamic> decodedOutfits = jsonDecode(outfitsString);
      _dailyOutfits.clear();
      final loadedOutfits = decodedOutfits.map((json) => Outfit.fromJson(json)).toList();
      final validOutfits = loadedOutfits.where((outfit) {
        return DateTime.now().difference(outfit.createdAt).inHours < 24;
      }).toList();
      _dailyOutfits.addAll(validOutfits);
    }
    
    notifyListeners();
  }

  void addItem(ClothingItem item) {
    _items.add(item);
    _saveToPrefs();
    notifyListeners();
  }

  void updateItem(ClothingItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    _currentOotd.removeWhere((item) => item.id == id);
    _favorites.removeWhere((item) => item.id == id);
    _saveToPrefs();
    notifyListeners();
  }

  void addToOotd(ClothingItem item) {
    if (!_currentOotd.any((element) => element.id == item.id)) {
      _currentOotd.add(item);
      notifyListeners();
    }
  }

  void addOutfit(Outfit outfit) {
    _dailyOutfits.insert(0, outfit); // Add to top
    _saveToPrefs();
    notifyListeners();
  }

  void deleteOutfit(String outfitId) {
    _dailyOutfits.removeWhere((o) => o.id == outfitId);
    _saveToPrefs();
    notifyListeners();
  }

  void toggleFavorite(ClothingItem item) {
    if (isFavorite(item.id)) {
      _favorites.removeWhere((i) => i.id == item.id);
    } else {
      _favorites.add(item);
    }
    _saveToPrefs();
    notifyListeners();
  }

  void clearWardrobe() {
    _items.clear();
    _favorites.clear();
    _collections.clear();
    _saveToPrefs();
    notifyListeners();
  }

  void loadDummyData() {
    if (_items.isEmpty) {
      _items.addAll(DummyData.wardrobeItems);
      _saveToPrefs();
      notifyListeners();
    }
  }

  List<ClothingItem> searchItems(String query, String filterTag) {
    return _items.where((item) {
      final matchesQuery = item.title.toLowerCase().contains(query.toLowerCase()) || 
                           item.brand.toLowerCase().contains(query.toLowerCase());
      
      bool matchesTag = true;
      if (filterTag == '#Oversized') {
         // simulate logic
      } else if (filterTag == '#EarthTones') {
         // simulate logic
      }
      
      // Just simple query match for now unless tag implies logic
      return matchesQuery;
    }).toList();
  }
}
