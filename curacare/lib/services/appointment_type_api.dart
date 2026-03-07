import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/appointment_type_data.dart';

class AppointmentTypeApi {

  static Future<List<AppointmentTypeData>> fetchAppointmenttype() async {
    final url = Uri.parse('http://10.0.2.2:5000/api/appointment-type');
    final response = await http.get(url).timeout(Duration(seconds: 5));

    if(response.statusCode == 200){
      final List<dynamic> rawList = jsonDecode(response.body);
      // log("Appointmenttype json data : ${rawList}");
      final List<AppointmentTypeData> result = []; 
      for(final item in rawList){
        result.add(AppointmentTypeData.fromJson(item));
      }
      return result;
    }else{
      throw Exception("cannot load appointmenttype data");
    }
  }
 
}