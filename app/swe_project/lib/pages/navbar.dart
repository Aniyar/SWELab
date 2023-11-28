import 'package:flutter/material.dart';
import 'package:swe_project/pages/home.dart';
import 'package:swe_project/pages/tasks.dart';
import 'package:swe_project/pages/history.dart';
import 'package:swe_project/pages/driverinfo.dart';
import 'package:swe_project/Classes/user.dart';
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    List<User> driver = [

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
