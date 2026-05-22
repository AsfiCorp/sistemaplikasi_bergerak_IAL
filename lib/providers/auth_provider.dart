import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic> _registeredUsers = {};
  Set<String> _registeredUsernames = {};
  
  bool _isLoggedIn = false;
  bool _isInitialized = false;
  String? _currentUserEmail;
  String? _currentUsername;
  String? _currentName;
  String? _joinDate;

  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUsername => _currentUsername;
  String? get currentName => _currentName;
  String? get joinDate => _joinDate;

  AuthProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load registered users
    final usersJson = prefs.getString('registeredUsers');
    if (usersJson != null) {
      final dynamic decoded = jsonDecode(usersJson);
      if (decoded is Map<String, dynamic>) {
        // Check if old format (values are strings)
        if (decoded.isNotEmpty && decoded.values.first is String) {
          // Migrate
          _registeredUsers = {};
          decoded.forEach((key, value) {
            _registeredUsers[key] = {
              'password': value,
              'name': 'User',
              'username': '@user',
              'joinDate': DateTime.now().toIso8601String(),
            };
          });
        } else {
          _registeredUsers = Map<String, dynamic>.from(decoded);
        }
      }
    } else {
      // Default dummy user
      _registeredUsers = {
        'dummyatha@gmail.com': {
          'password': '123456',
          'name': 'Athaillah',
          'username': '@dummy_atha',
          'joinDate': DateTime.now().toIso8601String()
        }
      };
      await prefs.setString('registeredUsers', jsonEncode(_registeredUsers));
    }

    // Load registered usernames
    final usernamesList = prefs.getStringList('registeredUsernames');
    if (usernamesList != null) {
      _registeredUsernames = usernamesList.toSet();
    } else {
      _registeredUsernames = {'@dummy_atha'};
      await prefs.setStringList('registeredUsernames', _registeredUsernames.toList());
    }

    // Check login state
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _currentUserEmail = prefs.getString('currentUserEmail');
    
    if (_isLoggedIn && _currentUserEmail != null && _registeredUsers.containsKey(_currentUserEmail)) {
      final userData = _registeredUsers[_currentUserEmail] as Map<String, dynamic>;
      _currentName = userData['name'] ?? 'User';
      _currentUsername = userData['username'] ?? '@user';
      _joinDate = userData['joinDate'] ?? DateTime.now().toIso8601String();
    } else {
      _isLoggedIn = false;
      _currentUserEmail = null;
      _currentName = null;
      _currentUsername = null;
      _joinDate = null;
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registeredUsers', jsonEncode(_registeredUsers));
    await prefs.setStringList('registeredUsernames', _registeredUsernames.toList());
  }

  Future<bool> signIn(String email, String password) async {
    if (_registeredUsers.containsKey(email)) {
      final userData = _registeredUsers[email] as Map<String, dynamic>;
      if (userData['password'] == password) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('currentUserEmail', email);
        
        _isLoggedIn = true;
        _currentUserEmail = email;
        _currentName = userData['name'] ?? 'User';
        _currentUsername = userData['username'] ?? '@user';
        _joinDate = userData['joinDate'] ?? DateTime.now().toIso8601String();
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<String?> signUp(String name, String username, String email, String password) async {
    if (_registeredUsers.containsKey(email)) {
      return 'Email is already registered';
    }
    if (_registeredUsernames.contains(username)) {
      return 'Username is already taken';
    }
    
    final now = DateTime.now().toIso8601String();
    
    _registeredUsers[email] = {
      'password': password,
      'name': name,
      'username': username,
      'joinDate': now
    };
    _registeredUsernames.add(username);
    
    await _saveUsers();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('currentUserEmail', email);
    
    _isLoggedIn = true;
    _currentUserEmail = email;
    _currentUsername = username;
    _currentName = name;
    _joinDate = now;
    notifyListeners();
    
    return null; // Success
  }

  Future<void> updateName(String newName) async {
    if (_currentUserEmail == null) return;
    
    _currentName = newName;
    if (_registeredUsers.containsKey(_currentUserEmail)) {
      _registeredUsers[_currentUserEmail!]['name'] = newName;
      await _saveUsers();
    }
    notifyListeners();
  }

  bool checkEmailExists(String email) {
    return _registeredUsers.containsKey(email);
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('currentUserEmail');
    
    _isLoggedIn = false;
    _currentUserEmail = null;
    _currentUsername = null;
    _currentName = null;
    _joinDate = null;
    notifyListeners();
  }
}
