import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/medicinedata.dart';

class MedicineApi {
  static Future<List<Medicinedata>> fetchMedicine() async {
    final url = Uri.parse('http://10.0.2.2:5000/api/medicine');
    final response = await http.get(url).timeout(Duration(seconds: 5));
    log("STATUS CODE => ${response.statusCode}");
    log("BODY => ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> rawList = jsonDecode(response.body);
      log("Rawlist ===> ${rawList}");
      final List<Medicinedata> result = [];
      for (final item in rawList) {
        result.add(Medicinedata.fromJson(item));
      }
      return result;
    } else {
      throw Exception("cannot load data");
    }
  }

  static Future<void> addMedicineToUser({
    required int medicineId,
    required int userId,
  }) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/user-medicine');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"medicine_id": medicineId, "user_id": userId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("บันทึกไม่สำเร็จ");
    }
  }

  static Future<void> deleteMedicine({
    required int medicineId,
    required int userId,
  }) async {
    final url = Uri.parse(
      'http://10.0.2.2:5000/api/user-medicine/${medicineId}/${userId}',
    );
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception("ลบไม่สำเร็จ");
    }
  }
}
