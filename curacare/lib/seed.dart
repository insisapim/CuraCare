import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

Future<void> reCreatedDB() async {
  final db = FirebaseFirestore.instance;

  try {
    final file = await rootBundle.loadString("lib/assets/seed.json");
    final List<dynamic> jsonData = jsonDecode(file);
    final conditions = db.collection("conditions");

    for (Map<String, dynamic> condition in jsonData) {
      conditions.add(condition);
    }
  } catch (e) {
    log(e.toString());
  }
}
