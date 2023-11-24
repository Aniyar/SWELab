import 'package:flutter/material.dart';
import 'package:swe_project/pages/home.dart';


class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  // Controllers to manage the input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables to store the entered email and password
  String userEmail = '';
  String userPassword = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),

            // Email input field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Password input field
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),

            // Login button
            ElevatedButton(
              onPressed: () {
                // Capture the entered values
                userEmail = _emailController.text;
                userPassword = _passwordController.text;

                // Check if credentials are correct
                if (userEmail == 'dinmukhamedtolegenov' &&
                    userPassword == 'swelab') {
                  // Navigate to the next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  // TODO: Handle incorrect credentials (e.g., show an error message)
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),

            // Contact information
            Text(
              'If you do not have an account, please, contact our administrator:',
              style: TextStyle(fontSize: 12.0),
            ),
            Text(
              'swe_admin@gmail.com',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

