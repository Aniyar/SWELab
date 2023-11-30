
import 'dart:convert';
import 'package:swe_project/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Classes/driver.dart';
class ConfirmDriverPage extends StatefulWidget {
  const ConfirmDriverPage({super.key});

  @override
  State createState() => _ConfirmDriverPageState();
}

class _ConfirmDriverPageState extends State {

  final TextEditingController _AdressController = TextEditingController();
  final TextEditingController _LicenseNController = TextEditingController();

  String userAddress = '';
  String userLicenseN = '';

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


  Future<http.Response> _createDriver(String address, String licenseNumber, String token) async
  {
    var authresponse = await http.post(
        Uri.parse('http://51.20.192.129:80/drivers'),
        headers: {
          'Authorization': 'Bearer ' + await token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String,String>{
          'address' : address,
          'licenseNumber' : licenseNumber,
        })

    );
    return authresponse;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey[200],
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  'Confirm information',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),

                TextFormField(
                  controller: _AdressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),

                // Password input field
                TextFormField(
                  controller: _LicenseNController,
                  decoration: InputDecoration(
                    labelText: 'LicenseNumber',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),

                // Login button
                ElevatedButton(
                  onPressed: () async {
                    // Capture the entered values
                    String token = await _loadAuthToken();
                    userAddress = _AdressController.text;
                    userLicenseN = _LicenseNController.text;
                    Driver driver = await _fetchDriver();
                    int driverId = driver.id;
                    if(userAddress != '' || userLicenseN !='') {
                      http.Response createReponse = await _createDriver(userAddress, userLicenseN, token);
                      if(createReponse.statusCode >= 200 && createReponse.statusCode < 300)
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage(driverId: driverId,)),
                          );
                        }
                      else
                        {
                          print("there is nothing we can do ${createReponse.statusCode}");
                        }
                    }

                  },
                  child: const Text('Confirm'),
                ),
                const SizedBox(height: 16.0),
             ],
            ),
          ),
        ),
    );
    }

}