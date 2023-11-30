import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe_project/pages/StaffHome.dart';
import 'package:swe_project/pages/driverconfirmation.dart';
import 'package:swe_project/pages/fueling_person_app.dart';
import 'package:swe_project/pages/login.dart';
import 'package:swe_project/pages/maintenance.dart';
import 'Classes/driver.dart';
import 'Classes/pair.dart';
import 'pages/home.dart';
import 'package:swe_project/Classes/user.dart';
import '/Classes/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swe_project/Classes/user.dart';
import 'package:http/http.dart' as http;
void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp()
  ));
}
int id = 1;

class MyApp extends StatelessWidget {

  MyApp({super.key});
  @override
  // This widget is the root of your application.
  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }


  Future<Driver> _fetchDriver() async
  {
    String token = await _loadAuthToken();
    http.Response response = await _getDriver(token);
    Driver driver = Driver.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
    return driver;
  }
  Future<http.Response> _getDriver(String token) async
  {

    var driverresponse = await http.get(
      Uri.parse('http://51.20.192.129:80/drivers/current'),
      headers: {
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
    );
    return driverresponse;
  }

  Future<http.Response> _getUser() async
  {
    var authresponse = await http.get(
      Uri.parse('http://51.20.192.129:80/users/my'),
      headers: {
        'Authorization': 'Bearer ' + await _loadAuthToken(),
        'Content-Type': 'application/json',
      },
    );
    return authresponse;
  }

  Future<User> _fetchUser(http.Response response) async
  {
    return User.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
  }

  Future<void> _saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }


Future<User?> _isUserLogin() async{

    _saveAuthToken('');
    var authresponse = await _getUser();

    if(await _loadAuthToken() == '' || authresponse.statusCode != 200 )
      {
        return null;
      }
    else
      {
        User user = await _fetchUser(authresponse);
        if(user.role == 'driver')
          {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            id = int.parse(prefs.getString('driverId')!);
          }
        return user;
      }
}


  @override
  Widget build(BuildContext context) {

      return FutureBuilder<User?>(
          future: _isUserLogin(),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null)
                {
                  return const MyLoginPage();
                }
              else {
                if (snapshot.data?.role == 'driver') {

                  return HomePage(driverId: id);
                }
                if (snapshot.data?.role == 'staff' || snapshot.data?.role == 'admin') {
                  return StaffHomePage(user: snapshot.data!);
                }
                if (snapshot.data?.role == 'maintenance') {
                  return MaintenancePage(); // Redirect to MaintenancePage
                }
                if (snapshot.data?.role == 'fuel') {
                  return FuellingPersonApp(); // Redirect to MaintenancePage
                }
                else {
                  return const MyLoginPage();
                }
              }
    }
            else
              {
                return CircularProgressIndicator();
              }
    });
  }
}

