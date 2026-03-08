
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine_model.dart';

class MedicineService {
  static final db = FirebaseFirestore.instance.collection("medicines");

  static Future<List<MedicineModel>> get() async {
    final data = await db.get();
    return (data.docs.map((medicine) {
      final map = medicine.data();
      map["id"] = medicine.id;
      return MedicineModel.fromJson(map);
    })).toList();
  }

  static Future<MedicineModel?> getById(String id) async {
    final data = await db.doc(id).get();
    final map = data.data();
    if (map == null) return null;
    map["id"] = data.id;
    return MedicineModel.fromJson(map);
  }
}
