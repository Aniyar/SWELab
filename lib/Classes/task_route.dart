import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:swe_project/Classes/user.dart';
import 'driver.dart';

Future<String> _loadAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
}
class Task_route {
  final int route_id;
  final Driver driver;
  var staff;
  var vehicle;
  final String startPoint;
  final String startLat;
  final String startLon;
  final String endPoint;
  final String endLat;
  final String endLon;
  var startTime;
  var endTime;
  final String status;

  Task_route({
    required this.route_id,
    required this.driver,
    required this.staff,
    required this.vehicle,
    required this.startPoint,
    required this.startLat,
    required this.startLon,
    required this.endPoint,
    required this.endLat,
    required this.endLon,
    required this.startTime,
    required this.endTime,
    required this.status,

  });
  factory Task_route.fromJson(Map<String, dynamic> json) {
    return Task_route(
      route_id: json['id'] as int,
      driver: Driver.fromJson(json['driver']),
      staff: json['staff'], // Adjust the type of 'staff' based on your data structure
      vehicle: json['vehicle'], // Adjust the type of 'vehicle' based on your data structure
      startPoint: json['startPoint'] as String,
      startLat: json['startLat'] as String,
      startLon: json['startLon'] as String,
      endPoint: json['endPoint'] as String,
      endLat: json['endLat'] as String,
      endLon: json['endLon'] as String,
      startTime: json['startTime'], // Adjust the type of 'startTime' based on your data structure
      endTime: json['endTime'], // Adjust the type of 'endTime' based on your data structure
      status: json['status'] as String,
    );
  }


}


    Future<void> ChangeStatus(String routeId, String status) async
    {
      var authresponse = await http.put(
        Uri.parse('http://51.20.192.129:80/routes/$routeId/change-status/$status'),
        headers: {
          'Authorization': 'Bearer ' + await _loadAuthToken(),
          'Content-Type': 'application/json',
        },
      );
      if(authresponse.statusCode == 200) {

      }
      else {

      }
      }

