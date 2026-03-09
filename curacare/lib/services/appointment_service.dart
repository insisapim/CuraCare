import 'package:algoliasearch/algoliasearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/models/appointment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentService {
  static final db = FirebaseFirestore.instance.collection("appointments");
  
  static Future<List<AppointmentModel>> get() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }
    final data = await db
        .where("uid", isEqualTo: user.uid)
        .orderBy("dateTime")
        .get();
    return (data.docs.map((appointment) {
      final map = appointment.data();
      Timestamp t = appointment.data()['dateTime'];
      DateTime d = t.toDate();
      map["dateTime"] = d;
      map["id"] = appointment.id;
      return AppointmentModel.fromJson(map);
    })).toList();
  }

  static Future<void> add(
    String title,
    String location,
    DateTime dateTime,
    String detail,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    await db.add({
      "uid": user.uid,
      "title": title,
      "location": location,
      "dateTime": dateTime,
      "detail": detail,
    });
    return;
  }

  static Future<void> remove(String appointmentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("ไม่พบผู้ใช้");
    }
    final appointment = await db.doc(appointmentId).get();
    if (!appointment.exists) {
      throw Exception("ไม่พบนัดหมาย");
    }

    if (appointment.data()!["uid"] != user.uid) {
      throw Exception("ผู้ใช้ไม่ใช่เจ้าของ");
    }
    await db.doc(appointmentId).delete();
  }

  static Future<void> update(
    String appointmentId,
    String title,
    String location,
    DateTime dateTime,
    String detail,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("ไม่พบผู้ใช้");
    }
    final appointment = await db.doc(appointmentId).get();
    if (!appointment.exists) {
      throw Exception("ไม่พบนัดหมาย");
    }

    if (appointment.data()!["uid"] != user.uid) {
      throw Exception("ผู้ใช้ไม่ใช่เจ้าของ");
    }
    await db.doc(appointmentId).update({
      "title": title,
      "location": location,
      "datetime": dateTime,
      "detail": detail,
    });
  }
}
