

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/models/routine_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoutineService {
  static CollectionReference<Map<String, dynamic>> get db =>
      FirebaseFirestore.instance.collection("routines");

  static Future<List<RoutineModel>> get() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    final data = await db
        .where("uid", isEqualTo: user.uid)
        .orderBy("time.hour")
        .orderBy("time.minute")
        .get();

    return (data.docs.map((routine) {
      final map = routine.data();
      map["id"] = routine.id;
      return RoutineModel.fromJson(map);
    })).toList();
  }

  static Future<void> resetStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final data = await db.where("uid", isEqualTo: user.uid).get();

    for (var routine in data.docs) {
      await routine.reference.update({"isCompleted": false});
    }
  }

  static Future<void> add(String title, String detail, TimeOfDay time) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    await db.add({
      "uid": user.uid,
      "title": title,
      "detail": detail,
      "time": {"hour": time.hour, "minute": time.minute},
      "isCompleted": false,
    });
  }

  static Future<void> update(
    String id,
    String title,
    String detail,
    TimeOfDay time,
    bool isCompleted,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final data = await db.doc(id).get();
    if (data.data() == null) {
      return;
    }
    if (data.data()!["uid"] != user.uid) {
      return;
    }
    await data.reference.update({
      "title": title,
      "detail": detail,
      "time": {"hour": time.hour, "minute": time.minute},
      "isCompleted": isCompleted,
    });
  }

  static Future<void> remove(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final data = await db.doc(id).get();
    if (data.data() == null) {
      return;
    }
    if (data.data()!["uid"] != user.uid) {
      return;
    }
    await data.reference.delete();
  }

  static Future<int> getPercent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return 0;
    }
    final data = await db.where("uid", isEqualTo: user.uid).get();
    final routines = (data.docs.map((routine) {
      final map = routine.data();
      map["id"] = routine.id;
      return RoutineModel.fromJson(map);
    })).toList();

    int completes = 0;
    for (var routine in routines) {
      if (routine.isCompleted) {
        completes += 1;
      }
    }

    final double progress = completes / routines.length;

    return (progress * 100).floor();
  }

  static Future<RoutineModel?> getNext() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final timeNow = TimeOfDay.now();

    final data = await db
        .where("uid", isEqualTo: user.uid)
        .orderBy("time.hour")
        .orderBy("time.minute")
        .get();

    final routines = (data.docs.map((routine) {
      final map = routine.data();
      map["id"] = routine.id;
      return RoutineModel.fromJson(map);
    })).toList();

    final nextRoutines = routines.where(
      (routine) => routine.time.isAfter(timeNow),
    );

    return nextRoutines.first;
  }
}
