import 'package:flutter/material.dart';
import 'package:swe_project/pages/navbar.dart';
import 'package:swe_project/Classes/user.dart';

import '../Classes/driver.dart';
class DriverInfoPage extends StatelessWidget {
  final Driver driver;


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
            _buildInfoRow('Driver Firstname', driver.user.firstName),
            _buildInfoRow('Driver Lastname', driver.user.lastName),
            _buildInfoRow('Email', driver.user.email),
            _buildInfoRow('Phonenumber', driver.user.phoneNumber),
            _buildInfoRow('Role', driver.user.role),
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
            backgroundImage: NetworkImage(driver.user.photo),
          ),
        ),
        SizedBox(height: 16),
        Text(
          driver.user.firstName,
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



