import 'package:flutter/material.dart';
import 'package:swe_project/pages/navbar.dart';
import 'package:swe_project/Classes/user.dart';
class DriverInfoPage extends StatelessWidget {
  final User driver;

  const DriverInfoPage({Key? key, required this.driver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:NavBar(),
      appBar: AppBar(
        title: Text('Driver Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            SizedBox(height: 16),
            _buildInfoRow('Driver Firstname', driver.firstName),
            _buildInfoRow('Driver Lastname', driver.lastName),
            _buildInfoRow('Email', driver.email),
            _buildInfoRow('Phonenumber', driver.phoneNumber),
            _buildInfoRow('Assigned Vehicle ID', driver.role),
            SizedBox(height: 16),
            Text('Additional Information:', style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 16),
            Text('Trips Details:', style: Theme.of(context).textTheme.subtitle1),
            _buildTripsTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(driver.photo),
          ),
        ),
        SizedBox(height: 16),
        Text(
          driver.firstName,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildTripsTable() {
    // Implement your trips table here
    return Container();
  }
}



