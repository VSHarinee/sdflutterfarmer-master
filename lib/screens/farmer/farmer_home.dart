import 'package:farm2fork/screens/farmer/viewallproducts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_product_page.dart';
import 'orders_placed_page.dart';
import 'payment_status_page.dart';
import 'personalinfo.dart';
import 'package:farm2fork/screens/auth/user_type_selection.dart';// Import the user type selection page

class FarmerHome extends StatefulWidget {
  final String userId;
 // Accept userId as a parameter

  FarmerHome({required this.userId});


  @override
  _FarmerHomeState createState() => _FarmerHomeState();

}

class _FarmerHomeState extends State<FarmerHome> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Initialize _pages here to access widget.userId
    _pages = [
      AddProductPage(userId: widget.userId),
      OrdersPlacedPage(farmerId: widget.userId,),
      FarmerProductsPage(farmerId:widget.userId,),
      FarmerPersonalInfoPage(userId: widget.userId),

      // Pass userId to PersonalInfoPage
    ];
  }

  final List<String> _titles = [
    "Add Product",
    "Orders Placed",
    "View Products",
    "Personal Information",
  ];

  void _onSelectItem(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selecting an item
  }

  // Function to handle logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut(); // Sign out the user
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserTypeSelection()), // Navigate to the user type selection page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[800]),
              child: Text(
                'Farmer Dashboard',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Product'),
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Orders Placed'),
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('View Products'),
              onTap: () => _onSelectItem(2),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Personal Info'),
              onTap: () => _onSelectItem(3),
            ),

            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout, // Call the logout function
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}
