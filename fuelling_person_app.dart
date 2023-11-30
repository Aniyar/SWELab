// fuelling_person_app.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FuellingPersonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuelling Person App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FuellingPersonHomePage(),
    );
  }
}

class FuellingPersonHomePage extends StatefulWidget {
  @override
  _FuellingPersonHomePageState createState() => _FuellingPersonHomePageState();
}

class _FuellingPersonHomePageState extends State<FuellingPersonHomePage> {
  final String baseUrl = 'http://51.20.192.129:80/auth/login';

  List<Map<String, dynamic>> fuellingTasks = [];
  List<Map<String, dynamic>> fuellingHistoryTasks = [];
  Map<String, dynamic>? profileInfo;

  @override
  void initState() {
    super.initState();
    _fetchFuellingTasks();
  }

  Future<void> _fetchFuellingTasks() async {
    var url = Uri.parse('http://51.20.192.129:80/fuellings/');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> tasks = List.from(json.decode(response.body));
        setState(() {
          fuellingTasks = tasks;
        });
      } else {
        print("Failed to fetch fuelling tasks. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching fuelling tasks: $error");
      if (error is http.ClientException) {
        print("Response content: ${error.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuelling Person App'),
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
                    builder: (context) => FuellingHistoryPage(
                      fuellingHistoryTasks: fuellingHistoryTasks,
                    ),
                  ),
                );
              },
              child: Text('History of Records'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FuellingProfilePage(profileInfo: profileInfo),
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
                    builder: (context) => FuellingRecordsPage(
                      fuellingTasks: fuellingTasks,
                      onComplete: _finishTask,
                      onReport: _makeReport,
                    ),
                  ),
                );

                _fetchFuellingTasks();
              },
              child: Text('Records'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finishTask(Map<String, dynamic> task) async {
    setState(() {
      fuellingTasks.remove(task);
      fuellingHistoryTasks.add(task);
    });
  }

  void _makeReport(double cost, String fuelType, String liters, String vehiclePlateNumber) {
    var newTask = {
      'cost per litre': cost,
      'fuelType': fuelType,
      'liters': liters,
      'vehiclePlateNumber': vehiclePlateNumber,
    };
    fuellingTasks.add(newTask);
  }


}

class FuellingProfilePage extends StatelessWidget {
  final Map<String, dynamic>? profileInfo;

  FuellingProfilePage({required this.profileInfo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchProfileInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          if (snapshot.error is http.ClientException) {
            var clientException = snapshot.error as http.ClientException;
            if (clientException.message.contains('401')) {
              return Text('Unauthorized: Please log in');
            } else if (clientException.message.contains('404')) {
              return Text('Profile not found');
            }
          }
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

  Future<Map<String, dynamic>> _fetchProfileInfo() async {
    return {
      "username": "fuelling_person",
      "role": "fuelling",
      "firstName": "John",
      "lastName": "Doe",
      "email": "fuelling_person@arada.kz",
      "phoneNumber": "+77771234567",
    };
  }
}

class FuellingRecordsPage extends StatefulWidget {
  final List<Map<String, dynamic>> fuellingTasks;
  final Function(Map<String, dynamic>) onComplete;
  final Function(double, String, String, String) onReport;

  FuellingRecordsPage({
    required this.fuellingTasks,
    required this.onComplete,
    required this.onReport,
  });

  @override
  _FuellingRecordsPageState createState() => _FuellingRecordsPageState();
}

class _FuellingRecordsPageState extends State<FuellingRecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel Records'),
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
            for (var task in widget.fuellingTasks)
              Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Vehicle Plate Number: ${task["vehiclePlateNumber"]}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cost: \$${task["cost"]}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await widget.onComplete(task);
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
    String vehiclePlateNumber = '';
    String fuelType = '';
    double liters = 0.0;

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
                decoration: InputDecoration(labelText: 'Fuel Type'),
                onChanged: (value) {
                  fuelType = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Liters'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  liters = double.tryParse(value) ?? 0.0;
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
                Navigator.of(context).pop();
                widget.onReport(cost, fuelType, liters.toString(), vehiclePlateNumber);
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
    List<Map<String, dynamic>> searchResults = widget.fuellingTasks
        .where((task) =>
        task["vehiclePlateNumber"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

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

// ... (your imports remain unchanged)

class FuellingHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> fuellingHistoryTasks;

  FuellingHistoryPage({required this.fuellingHistoryTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Records'), // Changed app bar title
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
            for (var task in fuellingHistoryTasks)
              Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fuel Type: ${task["fuelType"] ?? 'N/A'}'), // Use "Fuel Type" instead of "Maintenance Type"
                      Text('Vehicle Plate Number: ${task["vehiclePlateNumber"] ?? 'N/A'}'),
                      Text('Cost: \$${task["cost"] ?? 0.0}'), // Provide a default value for cost if it's null
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

// ... rest of your code remains unchanged
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
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

void _performSearch(BuildContext context, String searchQuery, List<Map<String, dynamic>> fuellingHistoryTasks) {
  List<Map<String, dynamic>> searchResults = fuellingHistoryTasks
      .where((task) =>
      task["vehiclePlateNumber"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase()))
      .toList();

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
                    Text('Fuel Type: ${task["fuelType"] ?? 'N/A'}'), // Use "Fuel Type" instead of "Maintenance Type"
                    Text('Vehicle Plate Number: ${task["vehiclePlateNumber"] ?? 'N/A'}'),
                    Text('Cost: \$${task["cost"] ?? 0.0}'), // Provide a default value for cost if it's null
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

