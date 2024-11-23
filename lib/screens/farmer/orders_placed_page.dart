import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_details_page.dart';

class OrdersPlacedPage extends StatelessWidget {
  final String farmerId;

  OrdersPlacedPage({required this.farmerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('farmerId', isEqualTo: farmerId)
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
              String buyerId = order['buyerId'];
              String productName = order['productName'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Product: ${productName ?? 'No Name'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${order['quantity']} kg'),
                      Text('Price per kg: ₹${order['willingPrice']}'),
                      Text('Total Price: ₹${order['quantity'] * order['willingPrice']}'),
                      Text('Order Date: ${order['createdAt'].toDate()}'),
                      // Display buyer info
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(buyerId)
                            .get(),
                        builder: (context, buyerSnapshot) {
                          if (buyerSnapshot.connectionState == ConnectionState.waiting) {
                            return Text('Loading buyer info...');
                          }
                          if (buyerSnapshot.hasError || !buyerSnapshot.hasData || !buyerSnapshot.data!.exists) {
                            return Text('Buyer Info: Not available');
                          }
                          var buyerData = buyerSnapshot.data!.data() as Map<String, dynamic>;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Buyer Name: ${buyerData['name']}'),
                              Text('Phone Number: ${buyerData['phone'] ?? 'Not available'}'),
                              Text('Address: ${buyerData['address'] ?? 'Not available'}'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to OrderDetailsPage with necessary data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(
                          farmerId: farmerId,
                          buyerId: buyerId,
                          productName: productName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
