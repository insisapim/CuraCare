import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/models/user_model.dart';
import 'package:curacare/services/condition_service.dart';
import 'package:curacare/services/medicine_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final db = FirebaseFirestore.instance.collection("users");

  static final user = FirebaseAuth.instance.currentUser;

  static Future<void> createUser(String userId, String username) async {
    final Map<String, dynamic> map = {
      "uid": userId,
      "username": username,
      "medicines": [],
      "condition": [],
    };
    await db.add(map);
  }

  static Future<void> addMedicine({required String medicineId}) async {
    if (user == null) throw Exception("UnAuthorization");

    final medicine = await MedicineService.getById(medicineId);
    if (medicine == null) throw Exception("Medicine not exist");

    final data = await db.where({"uid": user!.uid}).get();
    final userData = data.docs.first;
    final map = userData.data();
    if (user == null) map["id"] = userData.id;

    final userModel = UserModel.fromJson(map);
    userModel.medicines.add(medicineId);

    await db.doc(userModel.id).update({"medicines": userModel.medicines});
  }

  static Future<void> removeMedicine({required String medicineId}) async {
    if (user == null) throw Exception("UnAuthorization");

    final data = await db.where({"uid": user!.uid}).get();
    final userData = data.docs.first;
    final map = userData.data();
    if (user == null) map["id"] = userData.id;

    final userModel = UserModel.fromJson(map);
    userModel.medicines.remove(medicineId);

    await db.doc(userModel.id).update({"medicines": userModel.medicines});
  }

  static Future<void> addCondition({required String conditionId}) async {
    if (user == null) throw Exception("UnAuthorization");

    final condition = await ConditionService.getById(conditionId);
    if (condition == null) throw Exception("Condition not exist");

    final data = await db.where({"uid": user!.uid}).get();
    final userData = data.docs.first;
    final map = userData.data();
    if (user == null) map["id"] = userData.id;

    final userModel = UserModel.fromJson(map);
    userModel.conditions.add(conditionId);

    await db.doc(userModel.id).update({"conditions": userModel.conditions});
  }

  static Future<void> removeCondition({required String conditionId}) async {
    if (user == null) throw Exception("UnAuthorization");

    final data = await db.where({"uid": user!.uid}).get();
    final userData = data.docs.first;
    final map = userData.data();
    if (user == null) map["id"] = userData.id;

    final userModel = UserModel.fromJson(map);
    userModel.conditions.remove(conditionId);

    await db.doc(userModel.id).update({"conditions": userModel.conditions});
  }
}
