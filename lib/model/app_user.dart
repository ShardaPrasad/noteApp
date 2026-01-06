import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final bool isActive;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      fullName: map['fullName'],
      email: map['email'],
      isActive: map['isActive'],
    );
  }
}
