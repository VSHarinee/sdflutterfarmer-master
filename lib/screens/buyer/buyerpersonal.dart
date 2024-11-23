import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyerPersonalInfoPage extends StatefulWidget {
  final String userId;

  BuyerPersonalInfoPage({required this.userId});

  @override
  _BuyerPersonalInfoPageState createState() => _BuyerPersonalInfoPageState();
}

class _BuyerPersonalInfoPageState extends State<BuyerPersonalInfoPage> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController addressController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    _fetchUserData();
  }

  // Fetch existing user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          nameController.text = userDoc['name'] ?? '';
          ageController.text = userDoc['age']?.toString() ?? '';
          addressController.text = userDoc['address'] ?? '';
          phoneController.text = userDoc['phone'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  // Update user data in Firestore
  Future<void> _updateUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'name': nameController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'address': addressController.text,
        'phone': phoneController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Information updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Update Information',
              style: TextStyle(
                color: Colors.green[800],
                fontSize: 20,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
