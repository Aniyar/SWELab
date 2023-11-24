import 'package:flutter/material.dart';
import 'navbar.dart';

class UserinfoPage extends StatelessWidget {
  const UserinfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        drawer:NavBar(),
        appBar: AppBar(
            title: Text('My information',
              style: TextStyle(color: Colors.yellowAccent),),
            iconTheme: IconThemeData(color: Colors.yellow),
            backgroundColor: Colors.brown
        ),
      ),
    );
  }
}
