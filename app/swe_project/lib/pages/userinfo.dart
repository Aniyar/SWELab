import 'package:flutter/material.dart';
import 'package:swe_project/pages/navbar.dart';
import 'package:swe_project/Classes/Driver.dart';
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
            _buildInfoRow('Driver Name', driver.name),
            _buildInfoRow('Government ID', driver.governmentID),
            _buildInfoRow('Address', driver.address),
            _buildInfoRow('Driving License Code', driver.drivingLicenseCode),
            _buildInfoRow('Assigned Vehicle ID', driver.assignedVehicleID),
            SizedBox(height: 16),
            Text('Additional Information:', style: Theme.of(context).textTheme.subtitle1),
            _buildInfoRow('Total Trips', driver.totalTrips.toString()),
            _buildInfoRow('Total Distance', driver.totalDistance),
            _buildInfoRow('Average Rating', driver.averageRating.toString()),
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
            backgroundImage: NetworkImage(driver.profilePictureUrl),
          ),
        ),
        SizedBox(height: 16),
        Text(
          driver.name,
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



