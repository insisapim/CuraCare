

import 'package:algoliasearch/algoliasearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/models/condition_model.dart';
import 'package:curacare/models/search_condition_model.dart';
import 'package:curacare/services/user_service.dart';

class ConditionService {
  static final db = FirebaseFirestore.instance.collection("conditions");

  static Future<List<SearchConditionModel>> search(String? query) async {
    final client = SearchClient(
      appId: "77DZOQTTBI",
      apiKey: "fd8f421272e7b39099b7ac23bf808a65",
    );
    final queryHits = SearchForHits(indexName: "articles", query: query ?? "");
    final responseHits = await client.searchIndex(request: queryHits);
    client.dispose();

    return (responseHits.hits.map(
      (condition) => SearchConditionModel.fromJson(condition.toJson()),
    )).toList();
  }

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

  static Future<List<ConditionModel>> getFromUser() async {
    final user = await UserService.getByUid();
    if (user == null) {
      throw Exception("Unauthorized");
    }
    if (user.conditions.isEmpty) {
      return [];
    }
    final data = await db
        .where(FieldPath.documentId, whereIn: user.conditions)
        .get();
    return (data.docs.map((condition) {
      final map = condition.data();
      map["id"] = condition.id;
      return ConditionModel.fromJson(map);
    })).toList();
  }
}
