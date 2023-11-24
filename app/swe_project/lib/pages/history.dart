import 'package:flutter/material.dart';
import 'navbar.dart';
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        drawer:NavBar(),
        appBar: AppBar(
            title: Text('Driving history',
                style: TextStyle(color: Colors.yellowAccent),),
            iconTheme: IconThemeData(color: Colors.yellow),
            backgroundColor: Colors.brown
        ),
      ),
    );
  }
}
