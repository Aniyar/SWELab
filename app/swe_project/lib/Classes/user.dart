import 'package:http/http.dart' as http;
import 'package:swe_project/Classes/Token.dart';
class User {
final int userId;
  final String username;
  final String role;
  final String firstName;
  final String lastName;
  final String email;

  final String phoneNumber;
  final String photo;


  // Constructor
  const User({
    required this.userId,
    required this.username,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.photo,

  });

  // Getters



  factory User.fromJson(Map<String, dynamic> json) {
  return switch (json) {
    {
    'id': int userId,
    'username' : String username,
    'role' : String role,
    'firstName' : String firstName,
    'lastName' : String lastName,
    'email' : String email,
    'phoneNumber' : String phoneNumber,
    'createdDate' : var Date,

    } =>
        User(
            userId : userId,
            username: username,
            role: role,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            photo: 'cat.png',

        ),
    _ => throw const FormatException('Failed to load User.'),
  };
}


}

