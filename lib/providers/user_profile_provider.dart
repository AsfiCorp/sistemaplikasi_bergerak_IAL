import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider with ChangeNotifier {
  String _username = '@user';
  String _bio = 'Vintage streetwear enthusiast. Collecting since 2018.';
  Uint8List? _profileImageBytes;
  String? _currentUserEmail;
  
  // Style Preferences
  bool _strictVintageMode = true;
  bool _allowModernMix = false;
  bool _earthTonesPriority = true;
  String _selectedFit = 'Oversized';

  // Notification Settings
  bool _pushEnabled = true;
  bool _emailEnabled = false;
  bool _newArrivals = true;
  bool _styleTips = false;

  // App Integrations
  bool _depopConnected = true;
  bool _grailedConnected = false;
  bool _instagramConnected = false;

  // Location
  String _userLocation = 'Bandung';

  String get username => _username;
  String get bio => _bio;
  Uint8List? get profileImageBytes => _profileImageBytes;

  bool get strictVintageMode => _strictVintageMode;
  bool get allowModernMix => _allowModernMix;
  bool get earthTonesPriority => _earthTonesPriority;
  String get selectedFit => _selectedFit;

  bool get pushEnabled => _pushEnabled;
  bool get emailEnabled => _emailEnabled;
  bool get newArrivals => _newArrivals;
  bool get styleTips => _styleTips;

  bool get depopConnected => _depopConnected;
  bool get grailedConnected => _grailedConnected;
  bool get instagramConnected => _instagramConnected;

  String get userLocation => _userLocation;

  Future<void> loadUserProfile(String email, String defaultUsername) async {
    _currentUserEmail = email;
    _username = defaultUsername;
    final prefs = await SharedPreferences.getInstance();
    
    final base64Image = prefs.getString('profile_pic_$_currentUserEmail');
    if (base64Image != null) {
      _profileImageBytes = base64Decode(base64Image);
    } else {
      _profileImageBytes = null;
    }
    notifyListeners();
  }

  void clearProfileState() {
    _currentUserEmail = null;
    _username = '@user';
    _bio = 'Vintage streetwear enthusiast. Collecting since 2018.';
    _profileImageBytes = null;
    notifyListeners();
  }

  Future<void> updateProfile(String newUsername, String newBio, {Uint8List? newImageBytes}) async {
    _username = newUsername;
    _bio = newBio;
    if (newImageBytes != null) {
      _profileImageBytes = newImageBytes;
      if (_currentUserEmail != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_pic_$_currentUserEmail', base64Encode(newImageBytes));
      }
    }
    notifyListeners();
  }

  void updateStylePreferences(bool strict, bool modern, bool earth, String fit) {
    _strictVintageMode = strict;
    _allowModernMix = modern;
    _earthTonesPriority = earth;
    _selectedFit = fit;
    notifyListeners();
  }

  void updateNotificationSettings(bool push, bool email, bool arrivals, bool tips) {
    _pushEnabled = push;
    _emailEnabled = email;
    _newArrivals = arrivals;
    _styleTips = tips;
    notifyListeners();
  }

  void updateIntegration(String platform, bool connected) {
    if (platform == 'depop') _depopConnected = connected;
    if (platform == 'grailed') _grailedConnected = connected;
    if (platform == 'instagram') _instagramConnected = connected;
    notifyListeners();
  }

  void updateLocation(String newLocation) {
    _userLocation = newLocation;
    notifyListeners();
  }
}
