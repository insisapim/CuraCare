import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/chronicdiseasedata.dart';

class ChronicdiseaseApi {
  static Future<List<Chronicdiseasedata>> fetchDisease() async {
    final url = Uri.parse('http://10.0.2.2:5000/api/diseases');
    final response = await http.get(url).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final List<dynamic> rawList = jsonDecode(response.body);
      log("Rawlist ===> ${rawList}");
      final List<Chronicdiseasedata> result = [];
      for (final item in rawList) {
        result.add(Chronicdiseasedata.fromJson(item));
      }
      return result;
    } else {
      throw Exception("cannot load data");
    }
  }

  static Future<void> addDiseaseToUser({
    required int diseaseId,
    required int userId,
  }) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/user-disease');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"disease_id": diseaseId, "user_id": userId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("บันทึกไม่สำเร็จ");
    }
  }

  static Future<void> deleteDisease({
    required int diseaseId,
    required int userId,
  }) async {
    final url = Uri.parse(
      'http://10.0.2.2:5000/api/user-disease/${diseaseId}/${userId}',
    );
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception("ลบไม่สำเร็จ");
    }
  }
}
