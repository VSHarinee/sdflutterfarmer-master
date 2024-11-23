// payment_page.dart
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final String userId;
  @override
  PaymentPage({required this.userId});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Complete Your Payment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement payment logic here
              },
              child: Text('Pay Now'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}