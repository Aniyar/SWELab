import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchProfileInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle specific HTTP status code errors
          if (snapshot.error is http.ClientException) {
            var clientException = snapshot.error as http.ClientException;
            if (clientException.message.contains('401')) {
              return Text('Unauthorized: Please log in');
            } else if (clientException.message.contains('404')) {
              return Text('Profile not found');
            }
          }
          // Generic error message
          return Text('Error loading profile information: ${snapshot.error}');
        } else {
          Map<String, dynamic> profileInfo = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Username: ${profileInfo["username"]}'),
                  Text('Role: ${profileInfo["role"]}'),
                  Text('First Name: ${profileInfo["firstName"]}'),
                  Text('Last Name: ${profileInfo["lastName"]}'),
                  Text('Email: ${profileInfo["email"]}'),
                  Text('Phone Number: ${profileInfo["phoneNumber"]}'),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> _fetchProfileInfo() async {
    var url = Uri.parse('http://51.20.192.129:80/users/my');

    try {
      var token = "your_auth_token_here"; // Replace with your actual authentication token
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwibmFtZSI6ImFkbWluIGFkbWluIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4iLCJpZCI6MSwiZXhwIjoxNzAyMTQyODI2LCJnaXZlbl9uYW1lIjoiYWRtaW4iLCJmYW1pbHlfbmFtZSI6ImFkbWluIiwiZW1haWwiOiJhZG1pbkBleGFtcGxlLmNvbSJ9.c9AYPGqnr8WlQOlZcxMfi84cVS1pgRHo4Pgd9C8qVs59TYuYSBMNkp_RABnGu2F5psUCHqMc9qdgGlhFMMYYVjaLsobyDQ2GocwlKdi9iXvEkUCttuX0ZI5G1OX4_3ACLfjXPioAy7yXye6KH1DuQz4BR_Zm2gAGGL4d_HieEOLDuIejW6vJJeBJNuBF1Lp2N8fCNa94wPSEVM0Ieg-26Flj3mwFeYY61soe2pwOfQXm9SCHSUKoozB-hvFhMlJdbZHQZ7G0uAlFz3bdy83H8HaoaTz4O9IKAiLASiBKTqCu8y6zSnJoPh9xQQUNaLw48FlVhkNs6CMN3D0QjD4VKA'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Throw specific exceptions for HTTP status codes
        if (response.statusCode == 401) {
          throw http.ClientException('Unauthorized');
        } else if (response.statusCode == 404) {
          throw http.ClientException('Not Found');
        } else {
          throw http.ClientException('Failed to fetch profile information. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      // Handle network error by throwing an exception
      throw Exception('Error fetching profile information: $error');
    }
  }

}
