import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/medicinedata.dart';

class MedicinebyidApi {
  static Future<List<Medicinedata>> fetchMedicine() async {
    final url = Uri.parse('http://10.0.2.2:5000/api/user_medicine');
    final response = await http.get(url).timeout(Duration(seconds: 2));
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
}
