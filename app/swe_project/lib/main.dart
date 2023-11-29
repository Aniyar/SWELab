import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe_project/pages/driverconfirmation.dart';
import 'package:swe_project/pages/login.dart';
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


Future<bool> _isUserLogin() async{

    _saveAuthToken('');
    var authresponse = await _getUser();

    if(await _loadAuthToken() == '' || authresponse.statusCode != 200 )
      {
        return false;
      }
    else
      {
        return true;
      }

}
  @override
  Widget build(BuildContext context) {
      return FutureBuilder<bool>(
          future: _isUserLogin(),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.data == true)
                {
                  return const ConfirmDriverPage();
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

