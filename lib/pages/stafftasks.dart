import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe_project/pages/task_page.dart';
import '../Classes/task_route.dart';
import '../Classes/user.dart';
import 'navbar.dart';
import 'package:http/http.dart' as http;



class StaffTasksPage extends StatefulWidget {

  final User user;

  StaffTasksPage({required this.user});

  _StaffTaskPageState createState() => _StaffTaskPageState();
}

class _StaffTaskPageState extends State<StaffTasksPage>
{
  List<Task_route> tasks = [];
  late User user;
  Task_route? activeTask;

  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }

  Future<List<Task_route>> _fetchRoutes(String driverId, String status) async {
    var authresponse = await http.get(
      Uri.parse('http://51.20.192.129:80/routes/all?staffId=$driverId&status=$status'),
      headers: {
        'Authorization': 'Bearer ' + await _loadAuthToken(),
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
    tasks = await _fetchRoutes(user.userId.toString(), "WAITING");
    activeTask = (await _fetchRoutes(user.userId.toString(), "IN_PROGRESS")).first;
  }





  void initState() {
    user = widget.user;
    super.initState();
    _getRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  StaffTasksPage(user: user,),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (activeTask != null)
            GestureDetector(
              onTap: () {
                // Handle the tap on the active task box
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskInfoPage(taskRoute: activeTask!),
                  ),
                );
              },
              child: ActiveTaskBox(activeTask: activeTask!),
            ),
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
        ],
      ),
    );
  }
}

class ActiveTaskBox extends StatelessWidget {
  final Task_route activeTask;

  ActiveTaskBox({required this.activeTask});

  void _handleButtonClick(Task_route task_route, String status) {
    _ChangeStatus(task_route.route_id.toString(), status);
  }

  Future<void> _ChangeStatus(String routeId, String status) async
  {
    var authresponse = await http.put(
      Uri.parse('http://51.20.192.129:80/routes/$routeId/change-status/$status'),
      headers: {
        'Authorization': 'Bearer ' + await _loadAuthToken(),
        'Content-Type': 'application/json',
      },
    );
    if(authresponse.statusCode == 200) {

    }
    else {

    }
  }
  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue, // Customize the color as needed
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Task',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text('Route ID: ${activeTask.route_id}'),
          Text('Driver: ${activeTask.driver.user.firstName}'),
          Text('Status: ${activeTask.status}'),
          ElevatedButton(
            onPressed: () {
              // Handle the tap on the "Completed" button
              _handleButtonClick(activeTask, "COMPLETED");
            },
            child: Text('Completed'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle the tap on the "Cancel" button
              _handleButtonClick(activeTask, "NEW");
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class TaskBox extends StatelessWidget {
  final Task_route task;


  void _handleButtonClick(Task_route task_route) {
    _ChangeStatus(task_route.route_id.toString(), 'IN_PROGRESS');
  }

  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }



  Future<void> _ChangeStatus(String routeId, String status) async
  {
    var authresponse = await http.put(
      Uri.parse('http://51.20.192.129:80/routes/$routeId/change-status/$status'),
      headers: {
        'Authorization': 'Bearer ' + await _loadAuthToken(),
        'Content-Type': 'application/json',
      },
    );
    if(authresponse.statusCode == 200) {

    }
    else {

    }
  }







  TaskBox({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
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
          // Add more task information as needed
          ElevatedButton(
            onPressed: () {
              // Handle the button press, you can navigate to a new page or perform any action
              _handleButtonClick(task);
            },
            child: Text('Take task'),
          )
        ],

      ),
    );

  }
}