import 'dart:convert';
import 'package:http/http.dart' as http;

class FirstaidApi {
  static const String baseUrl = 'http://10.0.2.2:4000';

  static Future<List<dynamic>> fetchFirstAidList() async {
    final res = await http.get(Uri.parse('$baseUrl/firstaid'));

    if (res.statusCode != 200) {
      throw Exception('Failed to load firstaid list');
    }
    final body = jsonDecode(res.body);
    print('$baseUrl/firstaid/1');

    return body['firstaid'];
  }

  static Future<Map<String, dynamic>> fetchFirstaidById(int id) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/firstaid?id=$id'));

      print('STATUS: ${res.statusCode}');
      print('BODY: ${res.body}');

      final body = jsonDecode(res.body);
      return body['firstaid'][0];
    } catch (e) {
      print('API ERROR: $e');
      rethrow;
    }
  }
}
