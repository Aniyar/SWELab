import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MaintenancePage extends StatefulWidget {

  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  // Assume the base URL for the API
  final String baseUrl = 'http://51.20.192.129:80/auth/login';

  // Maintenance tasks
  List<Map<String, dynamic>> maintenanceTasks = [];

  // History of tasks
  List<Map<String, dynamic>> historyTasks = [];

  // Profile information
  Map<String, dynamic>? profileInfo;

  @override
  void initState() {
    super.initState();
    // Fetch maintenance tasks and profile information when the page is created
    _fetchMaintenanceTasks();

  }

  // Fetch maintenance tasks from the server
  Future<void> _fetchMaintenanceTasks() async {
    var url = Uri.parse('http://51.20.192.129:80/maintenances/');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Successful response, parse and update tasks
        List<Map<String, dynamic>> tasks = List.from(json.decode(response.body));
        setState(() {
          maintenanceTasks = tasks;
        });
      } else {
        // Handle error response
        print("Failed to fetch maintenance tasks. Status code: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network error
      print("Error fetching maintenance tasks: $error");
      if (error is http.ClientException) {
        print("Response content: ${error.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (profileInfo != null) ...[
              Text('Username: ${profileInfo!["username"]}'),
              Text('Role: ${profileInfo!["role"]}'),
              Text('First Name: ${profileInfo!["firstName"]}'),
              Text('Last Name: ${profileInfo!["lastName"]}'),
              Text('Email: ${profileInfo!["email"]}'),
              Text('Phone Number: ${profileInfo!["phoneNumber"]}'),
              SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(
                      historyTasks: historyTasks,
                    ),
                  ),
                );
              },
              child: Text('History of Tasks'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
              child: Text('Profile'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TasksPage(
                      maintenanceTasks: maintenanceTasks,
                      onComplete: _finishTask,
                      onReport: _makeReport,
                    ),
                  ),
                );

                // Update the current page when returning from the TasksPage
                _fetchMaintenanceTasks();
              },
              child: Text('Tasks'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finishTask(Map<String, dynamic> task) async {

    setState(() {
      maintenanceTasks.remove(task);
      historyTasks.add(task);
    });
  }

  void _makeReport(double cost, String maintenanceType, String details, String vehiclePlateNumber) {
    // Add the new task to the local list (not connected to Swagger)
    var newTask = {
      'cost': cost,
      'maintenanceType': maintenanceType,
      'details': details,
      'vehiclePlateNumber': vehiclePlateNumber,
    };
    maintenanceTasks.add(newTask);
  }
}

// ... (ProfilePage, TasksPage, HistoryPage remain unchanged)

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchProfileInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle specific HTTP status code errors
          if (snapshot.error is http.ClientException) {
            var clientException = snapshot.error as http.ClientException;
            if (clientException.message.contains('401')) {
              return Text('Unauthorized: Please log in');
            } else if (clientException.message.contains('404')) {
              return Text('Profile not found');
            }
          }
          // Generic error message
          return Text('Error loading profile information: ${snapshot.error}');
        } else {
          Map<String, dynamic> profileInfo = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Username: ${profileInfo["username"]}'),
                  Text('Role: ${profileInfo["role"]}'),
                  Text('First Name: ${profileInfo["firstName"]}'),
                  Text('Last Name: ${profileInfo["lastName"]}'),
                  Text('Email: ${profileInfo["email"]}'),
                  Text('Phone Number: ${profileInfo["phoneNumber"]}'),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // Updated _fetchProfileInfo function with hardcoded profile information
  Future<Map<String, dynamic>> _fetchProfileInfo() async {
    // Hardcoded profile information
    return {
      "username": "manager",
      "role": "maintenance",
      "firstName": "John",
      "lastName": "Doe",
      "email": "manager@arada.kz",
      "phoneNumber": "+77771234567",
    };
  }
}

class TasksPage extends StatefulWidget {
  final List<Map<String, dynamic>> maintenanceTasks;
  final Function(Map<String, dynamic>) onComplete;
  final Function(double, String, String, String) onReport;

  TasksPage({
    required this.maintenanceTasks,
    required this.onComplete,
    required this.onReport,
  });

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _showReportDialog(context);
              },
              child: Text('Make a Report'),
            ),
            SizedBox(height: 20),
            for (var task in widget.maintenanceTasks)
              Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Maintenance Type: ${task["maintenanceType"]}'),
                  subtitle: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Details: ${task["details"]}'),
                        Text('Vehicle Plate Number: ${task["vehiclePlateNumber"]}'),
                        Text('Cost: \$${task["cost"]}'),
                      ],
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await widget.onComplete(task);
                      // Update the current page when a task is marked as completed
                      setState(() {});
                    },
                    child: Text('Finish'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    double cost = 0.0;
    String maintenanceType = '';
    String details = '';
    String vehiclePlateNumber = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Make a Report'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  cost = double.tryParse(value) ?? 0.0;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Maintenance Type'),
                onChanged: (value) {
                  maintenanceType = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Details'),
                onChanged: (value) {
                  details = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Vehicle Plate Number'),
                onChanged: (value) {
                  vehiclePlateNumber = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onReport(cost, maintenanceType, details, vehiclePlateNumber);
                Navigator.of(context).pop();
                // Update the current page when a new task is added
                setState(() {});
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Tasks'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Vehicle Plate Number'),
                onChanged: (value) {
                  searchQuery = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performSearch(context, searchQuery);
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _performSearch(BuildContext context, String searchQuery) {
    // Filter tasks based on the search query
    List<Map<String, dynamic>> searchResults = widget.maintenanceTasks
        .where((task) =>
        task["vehiclePlateNumber"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    // Display the search results
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Results'),
          content: Column(
            children: [
              for (var task in searchResults)
                ListTile(
                  title: Text('Maintenance Type: ${task["maintenanceType"]}'),
                  subtitle: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Details: ${task["details"]}'),
                        Text('Vehicle Plate Number: ${task["vehiclePlateNumber"]}'),
                        Text('Cost: \$${task["cost"]}'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> historyTasks;

  HistoryPage({required this.historyTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History of Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var task in historyTasks)
              Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Completed Task: ${task["details"]}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Maintenance Type: ${task["maintenanceType"]}'),
                      Text('Vehicle Plate Number: ${task["vehiclePlateNumber"]}'),
                      Text('Cost: \$${task["cost"]}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Tasks'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Vehicle Plate Number'),
                onChanged: (value) {
                  searchQuery = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performSearch(context, searchQuery);
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _performSearch(BuildContext context, String searchQuery) {
    // Filter tasks based on the search query
    List<Map<String, dynamic>> searchResults = historyTasks
        .where((task) =>
        task["vehiclePlateNumber"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    // Display the search results
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Results'),
          content: Column(
            children: [
              for (var task in searchResults)
                ListTile(
                  title: Text('Completed Task: ${task["details"]}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Maintenance Type: ${task["maintenanceType"]}'),
                      Text('Vehicle Plate Number: ${task["vehiclePlateNumber"]}'),
                      Text('Cost: \$${task["cost"]}'),
                    ],
                  ),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}