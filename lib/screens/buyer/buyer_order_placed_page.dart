import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersPlacedByBuyerPage extends StatelessWidget {
  final String userId;

  OrdersPlacedByBuyerPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('buyerId', isEqualTo: userId) // Fetch orders placed by this buyer
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders placed.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              String farmerId = order['farmerId'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Product: ${order['productName'] ?? 'No Name'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${order['quantity']} kg'),
                      Text('Price per kg: ₹${order['willingPrice']}'),
                      Text('Total Price: ₹${order['quantity'] * order['willingPrice']}'),
                      Text('Status: ${order['status']}'),
                      Text('Order Date: ${order['createdAt'].toDate()}'),
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(farmerId)
                            .get(),
                        builder: (context, farmerSnapshot) {
                          if (farmerSnapshot.connectionState == ConnectionState.waiting) {
                            return Text('Loading farmer info...');
                          }
                          if (farmerSnapshot.hasError || !farmerSnapshot.hasData || !farmerSnapshot.data!.exists) {
                            return Text('Farmer Info: Not available');
                          }
                          var farmerData = farmerSnapshot.data!.data() as Map<String, dynamic>;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Farmer Name: ${farmerData['name']}'),
                              Text('Phone Number: ${farmerData['phone'] ?? 'Not available'}'),
                              Text('Address: ${farmerData['address'] ?? 'Not available'}'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
