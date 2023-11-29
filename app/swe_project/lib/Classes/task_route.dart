import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe_project/Classes/Task.dart';
import 'package:http/http.dart' as http;
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
    return switch (json) {
      {
      'driver': Driver driver,
      'staff': var staff,
      'vehicle' : var vehicle,
      "startPoint": String startPoint,
      "startLat": String startLat,
      "startLon": String startLon,
      "endPoint": String endPoint,
      "endLat": String endLat,
      "endLon": String endLon,
      "startTime": var startTime,
      "endTime": var endTime,
      "status": String status,
      } =>
          Task_route(
            route_id: 1,
              driver: driver,
            staff: staff,
            vehicle: vehicle,
            startPoint: startPoint,
            startLat: startLat,
            startLon: startLon,
            endPoint: endPoint,
            endLat: endLat,
            endLon: endLon,
            startTime: startTime,
            endTime: endTime,
            status: status,
          ),
      _ => throw const FormatException('Failed to load token.'),
    };
  }

}
Future<List<Task_route>> fetchRoutes(String driverId, String status) async {
  var authresponse = await http.get(
    Uri.parse('http://51.20.192.129:80/routes/all?driverId=$driverId&status=$status'),
    headers: {
      'Authorization': 'Bearer ' + await _loadAuthToken(),
      'Content-Type': 'application/json',
    },
  );
  if(authresponse.statusCode == 200)
    {
      final List<dynamic> TaskRoutesJson = json.decode(authresponse.body);
      List<Task_route> Tasks = TaskRoutesJson.map((albumJson) => Task_route.fromJson(albumJson)).toList();
      return Tasks;
    } else {
    throw Exception('Failed to load albums');
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

