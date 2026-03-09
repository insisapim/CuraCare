import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curacare/models/medicine_model.dart';
import 'package:curacare/services/user_service.dart';

class MedicineService {
  static final db = FirebaseFirestore.instance.collection("medicines");

  static Future<List<MedicineModel>> get(String? query) async {
    if (query == null || query.trim().isEmpty) {
      final data = await db.get();
      return (data.docs.map((medicine) {
        final map = medicine.data();
        map["id"] = medicine.id;

        return MedicineModel.fromJson(map);
      })).toList();
    } else {
      final data = await db.where("name", isEqualTo: query).get();
      return (data.docs.map((medicine) {
        final map = medicine.data();
        map["id"] = medicine.id;

        return MedicineModel.fromJson(map);
      })).toList();
    }
  }

  static Future<MedicineModel?> getById(String medicineId) async {
    final data = await db.doc(medicineId).get();
    if (data.data() == null) {
      return null;
    }
    final map = data.data()!;
    map["id"] = data.id;
    return MedicineModel.fromJson(map);
  }

  static Future<List<MedicineModel>> getFromUser() async {
    final user = await UserService.getByUid();

    if (user == null || user.medicines.isEmpty) {
      return [];
    }

    final data = await db
        .where(FieldPath.documentId, whereIn: user.medicines)
        .get();

    return (data.docs.map((medicine) {
      final map = medicine.data();
      map["id"] = medicine.id;

      return MedicineModel.fromJson(map);
    })).toList();
  }
}
