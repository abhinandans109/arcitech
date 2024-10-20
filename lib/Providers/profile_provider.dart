import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String _profileImageUrl = '';
  String _name = '';
  String _email = '';
  bool _isLoading = false;

  String get profileImageUrl => _profileImageUrl;
  String get name => _name;
  String get email => _email;
  bool get isLoading => _isLoading;

  // Fetch user profile data
  Future<void> fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      _profileImageUrl = userProfile['profileImageUrl'] ?? '';
      _name = userProfile['name'] ?? '';
      _email = userProfile['email'] ?? '';
      notifyListeners();
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String name, String email, File? image) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _isLoading = true;
      notifyListeners();
      String imageUrl = _profileImageUrl;

      // Upload image if it's not null
      if (image != null) {
        // Upload to Firebase Storage
        Reference ref = FirebaseStorage.instance.ref().child('profile_images').child(user.uid);
        await ref.putFile(image);
        imageUrl = await ref.getDownloadURL();
      }

      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'profileImageUrl': imageUrl,
      });

      _profileImageUrl = imageUrl;
      _name = name;
      _email = email;
      _isLoading = false;
      notifyListeners();
    }
  }
}
