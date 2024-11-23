import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'buyer_home.dart';

class AddressVerificationPage extends StatefulWidget {
  final String userId;

  AddressVerificationPage({required this.userId});

  @override
  _AddressVerificationPageState createState() => _AddressVerificationPageState();
}

class _AddressVerificationPageState extends State<AddressVerificationPage> {
  String? name;
  String? phone;
  String? address;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'] ?? 'N/A';
          phone = userDoc['phone'] ?? 'N/A';
          address = userDoc['address'] ?? 'N/A';
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Show confirmation message
  void _confirmOrder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order has been placed successfully')),
    );

    // Delay navigation slightly to allow the Snackbar to show
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BuyerHome(userId: widget.userId)),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Verification'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please confirm your details before placing the order:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Name: ${name ?? 'Loading...'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Phone: ${phone ?? 'Loading...'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Address: ${address ?? 'Loading...'}', style: TextStyle(fontSize: 16)),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _confirmOrder(context),
                child: Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
