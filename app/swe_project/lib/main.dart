import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe_project/pages/driverconfirmation.dart';
import 'package:swe_project/pages/login.dart';
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


  Future<void> _saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }


Future<Pair> _isUserLogin() async{

    //_saveAuthToken('');
    var authresponse = await _getUser();

    if(await _loadAuthToken() == '' || authresponse.statusCode != 200 )
      {
        return Pair('',-1);
      }
    else
      {
        Driver driver = await _fetchDriver();
        return Pair(driver.user.role, driver.id);
      }

}
  @override
  Widget build(BuildContext context) {
      return FutureBuilder<Pair>(
          future: _isUserLogin(),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              int id = snapshot.data?.b;
              if(snapshot.data?.a == 'driver')
                {
                  return HomePage(driverId: id);
                }
              else
                {
                  return const MyLoginPage();
                }
    }
            else
              {
                return CircularProgressIndicator();
              }
    });
  }
}

