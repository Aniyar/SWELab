import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe_project/pages/task_page.dart';
import '../Classes/task_route.dart';
import '../Classes/user.dart';

import 'package:swe_project/pages/tasks.dart';
import 'package:http/http.dart' as http;

class StaffHistoryPage extends StatefulWidget {

  final User user;

  const StaffHistoryPage({required this.user});

  @override
  _StaffHistoryPageState createState() => _StaffHistoryPageState();
}
class _StaffHistoryPageState extends State<StaffHistoryPage>
{
  List<Task_route> tasks = [];
  late User user;
  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }

  Future<List<Task_route>> _fetchRoutes(String id, String status) async {
    var authresponse = await http.get(
      Uri.parse('http://51.20.192.129:80/routes/all?staffId=$id&status=$status'),
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
    tasks = await _fetchRoutes(user.userId.toString(), "COMPLETED");
  }

@override
  void initState() {
    user = widget.user;
    super.initState();
    _getRoutes();
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
                  builder: (context) => StaffHistoryPage(user: user,),
                ),
              );
            },
          ),
        ],
      ),
      body:
          Expanded(
            child: ListView.builder(
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
                  child: TaskBox(task: tasks[index]),
                );
              },
            ),
          ),
    );
  }
}


