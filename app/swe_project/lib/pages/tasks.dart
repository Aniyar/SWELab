import 'package:flutter/material.dart';
import 'navbar.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        drawer:NavBar(),
        appBar: AppBar(
            title: Text('Current tasks',
              style: TextStyle(color: Colors.yellowAccent),),
            iconTheme: IconThemeData(color: Colors.yellow),
            backgroundColor: Colors.brown
        ),
      ),
    );
  }
}
