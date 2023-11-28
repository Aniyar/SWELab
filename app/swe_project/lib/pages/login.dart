import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swe_project/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swe_project/Classes/Token.dart';
import 'package:swe_project/Classes/user.dart';
class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  // Controllers to manage the input fields
  String authToken = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables to store the entered email and password
  String userEmail = '';
  String userPassword = '';
  Future<void> _saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      return authToken = prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }

  Future<String> _fetchToken(http.Response response) async
  {
  return Token.fromJson(jsonDecode(response.body) as Map<String,dynamic>).token;
  }
  Future<User> _fetchUser(http.Response response) async
  {
    return User.fromJson(jsonDecode(response.body) as Map<String,dynamic>);
  }
  Future<String> _applogin (String username, String password) async
  {
    var url = Uri.http('51.20.192.129:80', 'auth/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      _saveAuthToken(await _fetchToken(response));
      print(_loadAuthToken());
      var authresponse = await http.get(
        Uri.parse('http://51.20.192.129:80/users/my'),
        headers: {
          'Authorization': 'Bearer ' + await _loadAuthToken(),
          'Content-Type': 'application/json',
        },
      );
      print("response: " + authresponse.body);
      if (authresponse.statusCode == 200) {
        User user = await _fetchUser(authresponse);
        return user.role;
      }
      else
        {
          print("something went wrong");
          return '';
        }
  }
  else
  {
    print("wrong input");
    return '';
  }
  }
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Scaffold(
  backgroundColor: Colors.grey[200],
  appBar: AppBar(
  title: Text('Welcome'),
  ),
  body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  // Title
  Text(
  'Login',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
  SizedBox(height: 16.0),

  // Email input field
  TextFormField(
  controller: _emailController,
  decoration: InputDecoration(
  labelText: 'Username',
  border: OutlineInputBorder(),
  ),
  ),
  SizedBox(height: 16.0),

  // Password input field
  TextFormField(
  controller: _passwordController,
  decoration: InputDecoration(
  labelText: 'Password',
  border: OutlineInputBorder(),
  ),
  obscureText: true,
  ),
  SizedBox(height: 16.0),

  // Login button
  ElevatedButton(
  onPressed: () async {
  // Capture the entered values
  userEmail = _emailController.text;
  userPassword = _passwordController.text;

  String user_role = await _applogin(userEmail, userPassword);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Check if credentials are correct
  if (user_role == 'driver')
  {

  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => HomePage()),
  );
  }
  else {
    print("Hello there " + user_role);

  // TODO: Handle incorrect credentials (e.g., show an error message)
  }
  },
  child: Text('Login'),
  ),
  SizedBox(height: 16.0),

  // Contact information
  Text(
  'If you do not have an account, please, contact our administrator:',
  style: TextStyle(fontSize: 12.0),
  ),
  Text(
  'swe_admin@gmail.com',
  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
  ),
  ],
  ),
  ),
  ),
  );
  }
  }


