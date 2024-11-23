// buyer_home.dart
import 'package:farm2fork/screens/auth/user_type_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'buyer_order_placed_page.dart';
import 'product_list_page.dart';
import 'order_status_page.dart';
import 'payment_page.dart';
import 'buyerpersonal.dart';

class BuyerHome extends StatefulWidget {
  final String userId;  // Add userId parameter to the constructor

  BuyerHome({required this.userId});  // Constructor

  @override
  _BuyerHomeState createState() => _BuyerHomeState();
}

class _BuyerHomeState extends State<BuyerHome> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ProductsAvailablePage(userId: widget.userId),  // Pass userId to pages
      OrdersPlacedByBuyerPage(userId: widget.userId),
      BuyerPersonalInfoPage(userId: widget.userId),
    ];
  }

  final List<String> _titles = [
    "Products Available",
    "Orders Placed",

    "Personal Information",
  ];

  void _onSelectItem(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selecting an item
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserTypeSelection()),
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
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Buyer Dashboard',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Products Available'),
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Orders Placed'),
              onTap: () => _onSelectItem(1),
            ),

            ListTile(
              leading: Icon(Icons.person),
              title: Text('Personal Information'),
              onTap: () => _onSelectItem(2),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}