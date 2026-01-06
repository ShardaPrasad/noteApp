import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ------------------
  /// Login + User Check
  /// ------------------
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    
    print("email: $email");
    print("password: $password");

    try {
      // 1️⃣ Login user
      final userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      print("uiduiduiduiduid: $uid");
      print("email: $email");
      print("email: $password");

      // 2️⃣ Check user document exists
      final userDoc =
      await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        // ❌ Firestore user not found → logout
        await _auth.signOut();
        return false;
      }

      // ✅ User exists
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Auth Error: ${e.code}');
      return false;
    }

  }

  /// Check session
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// ------------------
  /// Sign Up + Create User
  /// ------------------
  Future<bool> signUpUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      // 1️⃣ Create Auth user
      final userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2️⃣ Create Firestore user document
      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      return true; // ✅ Saved successfully
    } catch (e) {
      debugPrint('Signup Error: ${e}');

      return false; // ❌ Failed
    }
  }
}
