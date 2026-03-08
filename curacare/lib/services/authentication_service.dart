import 'dart:developer';

import 'package:curacare/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  static Future<AuthenticationResponse> signIn(
    String email,
    String password,
  ) async {
    try {
      log("firebase signIn start");
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("firebase signIn success ${credential.user?.uid}");

      return AuthenticationResponse(ok: true, message: "Done");
    } on FirebaseAuthException catch (e) {
      log(e.toString());
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
      log(e.toString());
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
