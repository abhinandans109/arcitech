import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  // Sign Up with Email and Password using Firebase Auth
  Future<String?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      _isAuthenticated = true;
      notifyListeners();
      return null;  // No error, return null
    } on FirebaseAuthException catch (e) {
      _isAuthenticated = false;
      _user = null;
      notifyListeners();

      // Return error messages based on FirebaseAuthException codes
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return 'An error occurred. Please try again.';
      }
    }
  }

  // Sign In with Email and Password using Firebase Auth
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      _isAuthenticated = true;
      notifyListeners();
      return null;  // No error, return null
    } on FirebaseAuthException catch (e) {
      _isAuthenticated = false;
      _user = null;
      notifyListeners();

      // Return error messages based on FirebaseAuthException codes
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password provided.';
      } else {
        return 'An error occurred. Please try again.';
      }
    }
  }

  // Sign Out function
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
