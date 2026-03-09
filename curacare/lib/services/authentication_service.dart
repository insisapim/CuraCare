import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthenticationService {
  static Future<AuthenticationResponse> signIn(
    String email,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? token = await FirebaseMessaging.instance.getToken();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({"fcmToken": token}, SetOptions(merge: true));

      return AuthenticationResponse(ok: true, message: "Done");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return AuthenticationResponse(
          ok: false,
          message: "อีเมลหรือรหัสผ่านไม่ถูกต้อง",
        );
      }
      return AuthenticationResponse(
        ok: false,
        message: "เกิดข้อผิดพลาดระหว่างเข้าสู่ระบบ",
      );
    } catch (e) {
      return AuthenticationResponse(
        ok: false,
        message: "เกิดข้อผิดพลาดระหว่างเข้าสู่ระบบ",
      );
    }
  }

  static Future<AuthenticationResponse> signUp(
    String email,
    String password,
    String username,
  ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      UserService.createUser(credential.user!.uid, username);
      return AuthenticationResponse(ok: true, message: "Done");
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'weak-password') {
        return AuthenticationResponse(ok: false, message: "รหัสผ่านง่ายเกินไป");
      } else if (e.code == 'email-already-in-use') {
        return AuthenticationResponse(ok: false, message: "อีเมลนี้ถูกใช้แล้ว");
      }
      return AuthenticationResponse(
        ok: false,
        message: "เกิดข้อผิดพลาดระหว่างลงทะเบียน",
      );
    } catch (e) {
      log(e.toString());
      return AuthenticationResponse(
        ok: false,
        message: "เกิดข้อผิดพลาดระหว่างลงทะเบียน",
      );
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

class AuthenticationResponse {
  final bool ok;
  final String message;

  AuthenticationResponse({required this.ok, required this.message});
}
