import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/models/user_model.dart';
import 'package:curacare/services/condition_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final db = FirebaseFirestore.instance.collection("users");

  static Future<UserModel?> getByUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    final data = await db.where("uid", isEqualTo: user.uid).get();
    if (data.docs.isEmpty) {
      return null;
    }
    final map = data.docs.first.data();
    map["id"] = data.docs.first.id;

    final model = UserModel.fromJson(map);
    return model;
  }

  static Future<void> createUser(String userId, String username) async {
    final Map<String, dynamic> map = {
      "uid": userId,
      "username": username,
      "medicines": [],
      "conditions": [],
    };
    await db.add(map);
  }

  static Future<void> addCondition({required String conditionId}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("UnAuthorization");

    final condition = await ConditionService.getById(conditionId);
    if (condition == null) throw Exception("Condition not exist");

    final data = await db.where("uid", isEqualTo: user.uid).get();
    final userData = data.docs.first;
    final map = userData.data();
    map["id"] = userData.id;

    final userModel = UserModel.fromJson(map);
    userModel.conditions.add(conditionId);

    await db.doc(userModel.id).update({"conditions": userModel.conditions});
  }

  static Future<void> removeCondition({required String conditionId}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("UnAuthorization");

    final data = await db.where("uid", isEqualTo: user.uid).get();
    final userData = data.docs.first;
    final map = userData.data();
    map["id"] = userData.id;

    final userModel = UserModel.fromJson(map);
    userModel.conditions.remove(conditionId);

    await db.doc(userModel.id).update({"conditions": userModel.conditions});
  }
}
