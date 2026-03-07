import 'package:curacare/models/condition_model.dart';
import 'package:curacare/models/medicine_model.dart';

class UserModel {
  final String id;
  final String uid;
  final String username;
  final List<String> medicines;
  final List<String> conditions;
  UserModel({
    required this.id,
    required this.uid,
    required this.username,
    required this.medicines,
    required this.conditions,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      uid: json['uid'],
      username: json['username'],
      medicines: json['medicines'],
      conditions: json['conditions'],
    );
  }
}
