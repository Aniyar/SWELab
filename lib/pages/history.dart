import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe_project/pages/task_page.dart';
import '../Classes/task_route.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {

  final int driverId;

  const HistoryPage({required this.driverId});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}
class _HistoryPageState extends State<HistoryPage>
{
  List<Task_route> tasks = [];
  late int driverId;
  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }

  Future<List<Task_route>> _fetchRoutes(String driverId, String status) async {
    var authresponse = await http.get(
      Uri.parse('http://51.20.192.129:80/routes/all?driverId=$driverId&status=$status'),
      headers: {
        'Authorization': 'Bearer ${await _loadAuthToken()}',
        'Content-Type': 'application/json',
      },
    );
    if(authresponse.statusCode == 200)
    {
      Map<String, dynamic> jsonMap = json.decode(authresponse.body) as Map<String, dynamic>;

      List<dynamic> taskListJson = jsonMap['content'];
      List<Task_route> taskList = taskListJson
          .map((taskJson) => Task_route.fromJson(taskJson))
          .toList();
      return taskList;
    } else {
      throw Exception('Failed to load routes');
    }
  }


  Future<void> _getRoutes() async
  {
    tasks = await _fetchRoutes(driverId.toString(), "COMPLETED");
    await Future.delayed(const Duration(seconds: 1));
  }

@override
  void initState() {
    driverId = widget.driverId;
    _getRoutes();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(driverId: driverId),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskInfoPage(taskRoute: tasks[index]),
                      ),
                    );
                  },
                  child: TaskBox(task: tasks[0]),
                );
              },
            ),
          );
  }
}

class TaskBox extends StatelessWidget {
  final Task_route task;
const TaskBox({required this.task});

@override
Widget build(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Route ID: ${task.route_id}'),
        Text('Driver: ${task.driver.user.firstName}'),
        Text('Status: ${task.status}'),

      ],

    ),
  );

}
}