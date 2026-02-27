import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/appointmentdata.dart';

class AppointmentsApi {
  static Future<List<Appointmentdata>> fetchAppointment() async {
    final url = Uri.parse('http://10.0.2.2:5000/api/appointment/1');
    final response = await http.get(url).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final List<dynamic> rawList = jsonDecode(response.body);
      log("Appointments json data : ${rawList}");
      final List<Appointmentdata> result = [];
      for (final item in rawList) {
        result.add(Appointmentdata.fromJson(item));
      }
      return result;
    } else {
      throw Exception("cannot load appointment data");
    }
  }

  static Future<void> addAppointment({
    required String title,
    required int userId,
    required String startTime,
    required String endTime,
    required String location,
    required int appointmentType,
  }) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/appointment');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "location": location,
        "appointmenttype_id": appointmentType,
        "start_date": startTime,
        "end_date": endTime,
        "patient_id": userId,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("บันทึกนัดหมายไม่สำเร็จ");
    }
  }
  static Future<void> editAppointment({
    required int id,
    required String title,
    required int userId,
    required String startTime,
    required String endTime,
    required String location,
    required int appointmentType,
  }) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/appointment');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "title": title,
        "location": location,
        "appointmenttype_id": appointmentType,
        "start_date": startTime,
        "end_date": endTime,
        "patient_id": userId,
      }),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("บันทึกนัดหมายไม่สำเร็จ");
    }
  }
  static Future<void> deleteAppointment({
    required int userId,
    required int appointmentId
  }) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/appointment/${appointmentId}/${userId}');
    final response = await http.delete(url);
    log("status : ${response.statusCode}");
    if (response.statusCode != 200) {
      throw Exception("ลบการนัดหมายไม่สำเร็จ");
    }
  }
}
