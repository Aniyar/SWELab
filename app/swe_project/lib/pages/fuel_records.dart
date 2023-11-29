import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecordsPage extends StatefulWidget {
  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final String baseUrl = 'http://51.20.192.129:80/auth/login';
  List<Map<String, dynamic>> fuelingTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchFuelingTasks();
  }

  Future<void> _fetchFuelingTasks() async {
    var url = Uri.parse('http://51.20.192.129:80/fuels/all?vehicleId=1&vehiclePlate=780ATA01&fuelPersonnelId=1&fuelType=GAS&page=1&size=20');

    try {
      var token = "your_auth_token_here"; // Replace with your actual authentication token
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> tasks = List.from(json.decode(response.body));
        setState(() {
          fuelingTasks = tasks;
        });
      } else {
        print("Failed to fetch fueling tasks. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching fueling tasks: $error");
      if (error is http.ClientException) {
        print("Response content: ${error.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fueling Records'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecordsPage(),
                  ),
                );
              },
              child: Text('Fueling Records'),
            ),
            SizedBox(height: 20),
            for (var task in fuelingTasks)
              Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Fueling Type: ${task["fuelingType"]}'),
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
                      _finishTask(task);
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

  void _finishTask(Map<String, dynamic> task) async {
    var url = Uri.parse('$baseUrl/api/fueling/complete');

    try {
      var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwibmFtZSI6ImFkbWluIGFkbWluIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4iLCJpZCI6MSwiZXhwIjoxNzAyMTUxMzk0LCJnaXZlbl9uYW1lIjoiYWRtaW4iLCJmYW1pbHlfbmFtZSI6ImFkbWluIiwiZW1haWwiOiJhZG1pbkBleGFtcGxlLmNvbSJ9.dG5BHN-Prl7Kf6hLGB6P-_FcnGBC1-X1Yt3Cvt0eqGUx8ssmvxJEvpHJjhvb-ud28eTwDQC6raUtRmIZcJcTCvya9gV65-fVwA10uBRPYxpDCyzKMXzL02mxyKAS1lz_urPHdnld112GIUGBVLrq9itpfu6DzX3aR8KR9o5xuAECDu55rirSFMJSdhh0dFEWwB9fPWpTNgPIM2fBxlpeUWaJV9GoECBMP_IaAeWDSHAn9bn7ZTxuRWxJNQ2sp1fRdRMNSZZDoUXmrT_CwPwssAvvrUgXbSBDHVHspGIpL7VEoRTD6eXwiWh5XMzT7K5tsyH3DJVKpspIARzJTMmgMg"; // Replace with your actual authentication token
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'taskId': task['id']}),
      );

      if (response.statusCode == 200) {
        // Task completion successful
        // You may want to update the UI or perform additional actions here
      } else {
        print("Failed to complete task. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error completing task: $error");
    }
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
    List<Map<String, dynamic>> searchResults = fuelingTasks
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
                  title: Text('Fueling Type: ${task["fuelingType"]}'),
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
