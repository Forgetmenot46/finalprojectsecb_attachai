import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profilesetup.dart';

class AuthService {
  static const String routeName = '/ProfileSetup';

  User? get currentUser => _auth.currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      showSnackbar(context, 'เข้าสู่ระบบส าเร็จ');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar(context, 'ไม่พบอีเมล์ของท่าน/ท่านกรอกอีเมล์ไม่ถูกต้อง');
      } else if (e.code == 'wrong-password') {
        showSnackbar(context, 'ท่านกรอกรหัสผ่านไม่ถูกต้อง');
      } else {
        showSnackbar(context, 'เกิดข้อผิดพลาด: ${e.message}');
      }
      return null;
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      showSnackbar(context, 'ลงทะเบียนสำเร็จ');
      if (userCredential.user != null) {
// Redirect to profile setup
        Navigator.pushReplacementNamed(context, profilesetup.routeName);
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar(context, 'รหัสผ่านที่ระบุไม่ปลอดภัย');
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(context, 'อีเมลนี้ถูกใช้ไปแล้ว');
      } else {
        showSnackbar(context, 'เกิดข้อผิดพลาด: ${e.message}');
      }
      return null;
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      showSnackbar(context, 'ออกจากระบบส าเร็จ');
    } catch (e) {
      showSnackbar(context, 'เกิดข้อผิดพลาดในการออกจากระบบ: $e');
    }
  }

  // Check if user is authenticated
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Method for showing Snackbar
  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // เพิ่มฟังก์ชันนี้ใน AuthService
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnackbar(context, 'ลิงก์รีเซ็ตรหัสผ่านถูกส่งไปยังอีเมล์ของท่าน');
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, 'เกิดข้อผิดพลาด: ${e.message}');
    }
  }
}

