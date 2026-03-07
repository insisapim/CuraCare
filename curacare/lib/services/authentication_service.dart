import 'dart:developer';

import 'package:curacare/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  static Future<AuthenticationResponse> signIn(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return AuthenticationResponse(ok: true, message: "Done");
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return AuthenticationResponse(
          ok: false,
          message: "Email or password are wrong",
        );
      }
      return AuthenticationResponse(
        ok: false,
        message: "Error while Singing in",
      );
    } catch (e) {
      log(e.toString());
      return AuthenticationResponse(
        ok: false,
        message: "Error while Singing in",
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
        return AuthenticationResponse(
          ok: false,
          message: "Password is too weak",
        );
      } else if (e.code == 'email-already-in-use') {
        return AuthenticationResponse(
          ok: false,
          message: "Email already exist",
        );
      }
      return AuthenticationResponse(
        ok: false,
        message: "Error while signing up",
      );
    } catch (e) {
      log(e.toString());
      return AuthenticationResponse(
        ok: false,
        message: "Error while signing up",
      );
    }
  }
}

class AuthenticationResponse {
  final bool ok;
  final String message;

  AuthenticationResponse({required this.ok, required this.message});
}
