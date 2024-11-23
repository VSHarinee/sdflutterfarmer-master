import 'package:flutter/material.dart';
import 'farmer_auth_screen.dart';
import 'buyer_auth_screen.dart';
import 'dart:ui'; // Import for ImageFilter

class UserTypeSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Path to your image asset
            fit: BoxFit.cover, // Cover the entire screen with the image
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Space between buttons
              SizedBox(height: 250),

              // Farmer button with custom button
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: _buildCustomButton(context, 'FARMER', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FarmerAuthScreen()),
                  );
                }),
              ),

              // Vertical space between buttons
              SizedBox(height: 20),

              // Buyer button with custom button
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: _buildCustomButton(context, 'BUYER', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuyerAuthScreen()),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method to create the custom button with blurred background
  Widget _buildCustomButton(BuildContext context, String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed, // Handle button tap
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Rounded corners for custom button
          border: Border.all(color: Colors.white10, width: 1), // Green border
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15), // Ensure border radius is applied
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect
            child: Container(
              width: double.infinity, // Make the container full width
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50), // Button padding
              color: Colors.white.withOpacity(0.2), // Glass effect with opacity
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 30, // Font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
