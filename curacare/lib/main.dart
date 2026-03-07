import 'package:curacare/app.dart';
import 'package:curacare/seed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final seed = false;
  if (seed) {
    await reCreatedDB();
  }

  runApp(const App());
}
