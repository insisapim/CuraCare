import 'package:cloud_firestore/cloud_firestore.dart';

class FirstAidService {
  static final db = FirebaseFirestore.instance.collection("first_aids");

  static Future<QuerySnapshot<Map<String, dynamic>>> get() async {
    final data = await db.get();

    return data;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> fetchFirstAidById(
    String id,
  ) async {
    final data = await db.doc(id).get();

    return data;
  }
}
