import 'package:flutter/material.dart';

class RoutineModel {
  final String id;
  final String uid;
  final String title;
  final String detail;
  final TimeOfDay time;
  final bool isCompleted;

  RoutineModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.detail,
    required this.time,
    required this.isCompleted,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    final timeMap = json["time"];
    final time = TimeOfDay(hour: timeMap["hour"], minute: timeMap["minute"]);

    return RoutineModel(
      id: json["id"],
      uid: json["uid"],
      title: json["title"],
      detail: json["detail"],
      time: time,
      isCompleted: json["isCompleted"],
    );
  }
}
