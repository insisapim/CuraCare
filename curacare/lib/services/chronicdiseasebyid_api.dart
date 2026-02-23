import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/chronicdiseasedata.dart';

class ChronicdiseaseByIdApi {
  static Future<List<Chronicdiseasedata>> fetchDisease() async {
    final url = Uri.parse('http://10.0.2.2:5000/api/user_disease');
    final response = await http.get(url).timeout(Duration(seconds: 2));


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
}
