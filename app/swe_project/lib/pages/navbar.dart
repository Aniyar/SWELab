import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe_project/pages/home.dart';
import 'package:swe_project/pages/tasks.dart';
import 'package:swe_project/pages/history.dart';
import 'package:swe_project/pages/driverinfo.dart';
import 'package:swe_project/Classes/user.dart';

import '../Classes/driver.dart';
class NavBar extends StatefulWidget {
 @override
 _NavbarState createState() => _NavbarState();
}
  class _NavbarState extends State<NavBar>
  {
  late String username;
  late String email;
  late String firstName;
  late String lastName;
  late Driver driver;
  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }

  Future<http.Response> _getDriver() async
  {
    var driverresponse = await http.get(
      Uri.parse('http://51.20.192.129:80/drivers/current'),
      headers: {
        'Authorization': 'Bearer ' + await _loadAuthToken(),
        'Content-Type': 'application/json',
      },
    );
    print(driverresponse.statusCode);
    return driverresponse;
  }

  _loadUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(()
    {
      username = prefs.getString('username')!;
      email = prefs.getString('email')!;
      firstName = prefs.getString('firstName')!;
      lastName = prefs.getString('lastName')!;
    });
  }

  Future<Driver> _fetchDriver() async
  {
    http.Response response = await _getDriver();
    return Driver.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
  }

  @override
  void initState(){
    super.initState();
    _loadUserName();
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(

              accountName: Text("$firstName $lastName"),
              accountEmail: Text(email),
              //currentAccountPicture: CircleAvatar(
                //child: ClipOval(child: Image.asset())
              //),
              decoration: BoxDecoration(
                color: Colors.amber
              )
          ),
          ListTile(
            //leading: const Icon(),
            title: const Text('Main page'),
            onTap: () async => {
              driver = await _fetchDriver(),
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(driverId: driver.id,))
            ),}
          ),
          ListTile(
            //leading: const Icon(),
            title: const Text('Tasks'),
            onTap: () async => {
              driver = await _fetchDriver(),
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TasksPage(driverId: driver.id,))
              ),}
          ),
          ListTile(
            //leading: const Icon(),
            title: const Text('History'),
              onTap: () async => {
              driver = await _fetchDriver(),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage(driverId: driver.id,))
            ),}
          ),
          ListTile(
            //leading: const Icon(),
            title: const Text('Personal_information'),
            onTap: () async =>
                {
                  driver = await _fetchDriver(),

                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriverInfoPage(driver: driver),
            ),
          ),
                }
      )
    ],
    ),
    );

  }
}
