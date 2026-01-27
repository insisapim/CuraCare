import 'dart:convert';
import 'dart:io';

import 'package:curacare/models/condition.dart';
import 'package:http/http.dart' as http;

Future<List<Condition>> getConditions(int page, String query) async {
  Map<String, String> params = {"page": "0", "limit": "20"};
  if (query != "") {
    params.addAll({"query": query});
  }

  final res = await http.get(Uri.http('10.0.2.2:4000', "/conditions", params));

  if (res.statusCode != 200) return [];

  final json = jsonDecode(res.body);

  return (json["conditions"] as List)
      .map((condition) => Condition.fromJson(condition))
      .toList();
}

Future<Condition> getConditionById(String id) async {
  final res = await http.get(Uri.parse("http://10.0.2.2:4000/conditions/$id"));

  if (res.statusCode != 200) throw HttpException("Failed to load condition");

  final json = jsonDecode(res.body) as Map<String, dynamic>;

  return Condition.fromJson(json['condition']);
}
