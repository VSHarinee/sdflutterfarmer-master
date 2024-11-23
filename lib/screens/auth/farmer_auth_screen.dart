import 'package:farm2fork/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../farmer/farmer_home.dart';

class FarmerAuthScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signIn(BuildContext context) async {
    try {
      // Authenticate using Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the authenticated user's unique ID
      String userId = userCredential.user!.uid;

      // Navigate to FarmerHome, passing the userId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FarmerHome(userId: userId)),
      );
    } catch (e) {
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Login',
        style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.green[800], // Green AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Farmer Email',
                labelStyle: TextStyle(color: Colors.green[800]), // Green label text
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[800]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[800]!),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.green[800]), // Green label text
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[800]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[800]!),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _signIn(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800], // Green background color
                foregroundColor: Colors.white, // White text
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to AuthScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen2()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[800], // Green text for the link
              ),
              child: Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
