import 'package:flutter/material.dart';
import 'package:swe_project/Classes/task_route.dart';

import '../Classes/driver.dart';



class TaskInfoPage extends StatelessWidget {

  final Task_route taskRoute;

  TaskInfoPage({required this.taskRoute});


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoItem('Route ID', '${taskRoute.route_id}'),
            _buildInfoItem(
                'Driver', '${taskRoute.driver.user.firstName} ${taskRoute.driver.user.lastName}'),
            _buildInfoItem('Start Point', '${taskRoute.startPoint}'),
            _buildInfoItem('Start Latitude', '${taskRoute.startLat}'),
            _buildInfoItem('Start Longitude', '${taskRoute.startLon}'),
            _buildInfoItem('End Point', '${taskRoute.endPoint}'),
            _buildInfoItem('End Latitude', '${taskRoute.endLat}'),
            _buildInfoItem('End Longitude', '${taskRoute.endLon}'),
            _buildInfoItem('Start Time', '${taskRoute.startTime}'),
            _buildInfoItem('End Time', '${taskRoute.endTime}'),
            _buildInfoItem('Status', '${taskRoute.status}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}