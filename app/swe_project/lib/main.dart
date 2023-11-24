import 'package:flutter/material.dart';
import 'pages/home.dart';

import '/Classes/Driver.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swe_project/pages/navbar.dart';
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
          home: HomePage()
      );
  }
}

