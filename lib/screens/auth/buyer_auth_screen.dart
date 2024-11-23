import 'package:farm2fork/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../buyer/buyer_home.dart';

class BuyerAuthScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String userId = userCredential.user!.uid;  // Get user ID from Firebase

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BuyerHome(userId: userId), // Pass userId to BuyerHome
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Login',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.green[800], // Set AppBar color to green[800]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Buyer Email',
                labelStyle: TextStyle(color: Colors.green[800]), // Set label color to green[800]
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
                labelStyle: TextStyle(color: Colors.green[800]), // Set label color to green[800]
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
                backgroundColor: Colors.green[800], // Set button color to green[800]
                foregroundColor: Colors.white, // White text
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to sign-up screen if needed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen2()), // Replace with actual sign-up screen
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[800], // Set text color to green[800]
              ),
              child: Text('No account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
