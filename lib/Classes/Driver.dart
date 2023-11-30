import 'dart:convert';
import 'package:swe_project/Classes/Token.dart';
import 'package:http/http.dart' as http;
import 'package:swe_project/Classes/user.dart';

class Driver
{
  final int id;
  final User user;

  final String address;
  final String licenseNumber;
  final int rating;
  var vehicle;

   Driver ({
    required this.user,
    required this.address,
    required this.licenseNumber,
    required this.vehicle,
    required this.id,
    required this.rating,
});
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as int,
      user: User.fromJson(json['user']),
      address: json['address'] as String,
      licenseNumber: json['licenseNumber'] as String,
      rating: json['rating'] as int,
      vehicle: json['vehicle'], // Adjust the type of 'vehicle' based on your data structure
    );
  }

}