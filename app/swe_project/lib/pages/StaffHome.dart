

import 'package:flutter/material.dart';

import '../Classes/user.dart';
import 'navbar.dart';
import 'navbarStaff.dart';




class StaffHomePage extends StatelessWidget {

  final User user;


  const StaffHomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:NavBarStaff(),
      appBar: AppBar(
        title: Text('Staff Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            SizedBox(height: 16),
            _buildInfoRow('Firstname', user.firstName),
            _buildInfoRow('Lastname', user.lastName),
            _buildInfoRow('Email', user.email),
            _buildInfoRow('Phonenumber', user.phoneNumber),
            _buildInfoRow('Role', user.role),
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
            backgroundImage: NetworkImage(user.photo),
          ),
        ),
        SizedBox(height: 16),
        Text(
          user.firstName,
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






