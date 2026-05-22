import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_profile_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  Uint8List? _newImageBytes;

  @override
  void initState() {
    super.initState();
    final profile = context.read<UserProfileProvider>();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.currentName ?? '');
    _usernameController = TextEditingController(text: profile.username);
    _bioController = TextEditingController(text: profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _newImageBytes = bytes;
      });
    }
  }

  void _saveProfile() {
    context.read<AuthProvider>().updateName(_nameController.text);
    context.read<UserProfileProvider>().updateProfile(
      _usernameController.text,
      _bioController.text,
      newImageBytes: _newImageBytes,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EDIT PROFILE')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Consumer<UserProfileProvider>(
              builder: (context, profile, child) {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: _newImageBytes != null
                      ? MemoryImage(_newImageBytes!)
                      : (profile.profileImageBytes != null
                          ? MemoryImage(profile.profileImageBytes!) as ImageProvider
                          : const NetworkImage('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80')),
                );
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Change Photo', style: TextStyle(color: AppTheme.primaryOlive, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              controller: _usernameController,
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              controller: _bioController,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('SAVE CHANGES'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
