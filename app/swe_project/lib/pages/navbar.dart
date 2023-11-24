import 'package:flutter/material.dart';
import 'package:swe_project/pages/home.dart';
import 'package:swe_project/pages/tasks.dart';
import 'package:swe_project/pages/history.dart';
import 'package:swe_project/pages/userinfo.dart';
import 'package:swe_project/Classes/Driver.dart';
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    List<Driver> driver = [
      Driver(
        name: 'John Doe',
        governmentID: '123456789',
        address: '123 Main Street, Anytown, CA 12345',
        drivingLicenseCode: 'L123456',
        assignedVehicleID: 'V123',
        performanceRating: 4.5,
        contactNumber: '+1 (555) 123-4567',
        drivingExperience: '5 years',
        averageRating: 4.8,
        totalTrips: '100',
        totalDistance: '500.0',
        profilePictureUrl: 'https://example.com/profile-picture.jpg',
      ),
    ];
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: const Text('hi'),
              accountEmail: const Text('hi@gmail.com'),
              //currentAccountPicture: CircleAvatar(
                //child: ClipOval(child: Image.asset())
              //),
              decoration: BoxDecoration(
                color: Colors.amber
              )
          ),
          ListTile(
            //leading: const Icon(),
            title: const Text('Main page'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage())
            ),
          ),
          ListTile(
            //leading: const Icon(),
            title: const Text('Tasks'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksPage())
            ),
          ),
          ListTile(
            //leading: const Icon(),
            title: const Text('History'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage())
            ),
          ),
          ListTile(
            //leading: const Icon(),
            title: const Text('Personal_information'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriverInfoPage(driver: driver[0])
            ),
          ),
      )
    ],
    ),
    );

  }
}
