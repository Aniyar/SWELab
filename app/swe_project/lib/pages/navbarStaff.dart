import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe_project/pages/StaffHome.dart';
import 'package:swe_project/pages/home.dart';
import 'package:swe_project/pages/stafftasks.dart';

import 'package:swe_project/Classes/user.dart';

import 'CreateRoute.dart';
import 'StaffHistoryPage.dart';
class NavBarStaff extends StatefulWidget {
  @override
  _NavbarStaffState createState() => _NavbarStaffState();
}
class _NavbarStaffState extends State<NavBarStaff>
{
  late String email;
  late String firstName;
  late String lastName;
  late User user;
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

  Future<User> _fetchUser() async
  {
    http.Response response = await _getUser();
    return User.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
  }

  _loadUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(()
    {
      email = prefs.getString('email')!;
      firstName = prefs.getString('firstName')!;
      lastName = prefs.getString('lastName')!;
    });
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
              title: const Text('Personal Information'),
              onTap: () async => {
            user = await _fetchUser(),
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StaffHomePage(user: user))
                ),
    }
    ),
          ListTile(
            //leading: const Icon(),
              title: const Text('History of routes'),
              onTap: () async => {
                user = await _fetchUser(),
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StaffHistoryPage(user: user))
                ),
              }
          ),
          ListTile(
            //leading: const Icon(),
              title: const Text('Waiting routes'),
              onTap: () async => {
                user = await _fetchUser(),
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StaffTasksPage(user: user))
                ),
              }
          ),
          ListTile(
            //leading: const Icon(),
              title: const Text('Create routes'),
              onTap: () async => {
                user = await _fetchUser(),
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StaffMapPage(user: user))
                ),
              }
          ),
        ],
      ),
    );

  }
}
