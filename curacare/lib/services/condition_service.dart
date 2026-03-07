import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/models/condition_model.dart';

class ConditionService {
  static final db = FirebaseFirestore.instance.collection("conditions");

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> get(
    int limit,
    DocumentSnapshot? lastDoc,
    String? search,
  ) async {
    var query = db.orderBy("views", descending: true).limit(limit);

    if (search != null && search.trim() != "") {
      query = query.where("name", isEqualTo: search);
    }

    if (lastDoc != null) {
      query = query.startAtDocument(lastDoc);
    }

    final data = await query.get();

    return data.docs;
  }

  static Future<ConditionModel?> getById(String id) async {
    final data = await db.doc(id).get();

    final map = data.data();
    if (map == null) return null;
    map["id"] = data.id;

    return ConditionModel.fromJson(map);
  }

  static Future<void> increaseView(String id) async {
    final db = FirebaseFirestore.instance;

    await db.collection("conditions").doc(id).update({
      "views": FieldValue.increment(1),
    });
  }
}
