import 'driver.dart';
class Task_route
{
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
  Task_route ({
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
}