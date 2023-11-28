import 'package:flutter/material.dart';
import 'package:swe_project/pages/login.dart';
import 'pages/home.dart';
import 'package:swe_project/Classes/user.dart';
import '/Classes/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swe_project/pages/navbar.dart';
import 'package:http/http.dart' as http;
void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
      return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyLoginPage()
      );
  }
}

