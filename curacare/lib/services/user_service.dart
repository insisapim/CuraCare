

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/models/user_model.dart';
import 'package:curacare/services/condition_service.dart';
import 'package:curacare/services/medicine_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final db = FirebaseFirestore.instance.collection("users");

  static Future<UserModel?> getByUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    final data = await db.doc(user.uid).get();
    final map = data.data()!;
    map["id"] = data.id;


    final model = UserModel.fromJson(map);
    return model;
  }

  static Future<void> createUser(String userId, String username) async {
    final Map<String, dynamic> map = {
      "username": username,
      "conditions": [],
      "medicines": [],
    };
    await db.doc(userId).set(map);
  }

  static Future<void> addCondition(String conditionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("UnAuthorization");

    final condition = await ConditionService.getById(conditionId);
    if (condition == null) throw Exception("Condition not exist");

    final data = await db.doc(user.uid).get();
    final map = data.data()!;
    map["id"] = data.id;

    final userModel = UserModel.fromJson(map);
    userModel.conditions.add(conditionId);

    await db.doc(userModel.id).update({"conditions": userModel.conditions});
  }

  static Future<void> removeCondition( String conditionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("UnAuthorization");

    final data = await db.doc(user.uid).get();
    final map = data.data()!;
    map["id"] = data.id;

    final userModel = UserModel.fromJson(map);
    userModel.conditions.remove(conditionId);

    await db.doc(userModel.id).update({"conditions": userModel.conditions});
  }

  static Future<void> addMedicine(String medicineId) async {
    final user = await UserService.getByUid();
    if (user == null) throw Exception("UnAuthorization");

    final medicine = await MedicineService.getById(medicineId);
    if (medicine == null) throw Exception("Medicine not exist");

    user.medicines.add(medicineId);

    await db.doc(user.id).update({"medicines": user.medicines});
  }

  static Future<void> removeMedicine(String medicineId) async {
    final user = await UserService.getByUid();
    if (user == null) throw Exception("UnAuthorization");

    final medicine = await MedicineService.getById(medicineId);
    if (medicine == null) throw Exception("Medicine not exist");

    user.medicines.remove(medicineId);

    await db.doc(user.id).update({"medicines": user.medicines});
  }
}
