import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatelessWidget {
  final String farmerId;
  final String buyerId;
  final String productName;

  OrderDetailsPage({
    required this.farmerId,
    required this.buyerId,
    required this.productName,
  });

  Future<void> updateOrderStatus(String status) async {
    try {
      // Find the order document that matches farmerId, buyerId, and productName
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('farmerId', isEqualTo: farmerId)
          .where('buyerId', isEqualTo: buyerId)
          .where('productName', isEqualTo: productName)
          .get();

      if (orderSnapshot.docs.isNotEmpty) {
        DocumentSnapshot orderDoc = orderSnapshot.docs.first;

        // Update the status of the order
        await orderDoc.reference.update({'status': status});
        print('Order status updated to $status');
      } else {
        print('Order not found');
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('orders')
            .where('farmerId', isEqualTo: farmerId)
            .where('buyerId', isEqualTo: buyerId)
            .where('productName', isEqualTo: productName)
            .limit(1) // Get the first matching document
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Order not found.'));
          }

          var orderData = snapshot.data!.docs.first.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product: ${orderData['productName']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Quantity: ${orderData['quantity']} kg'),
                Text('Price per kg: ₹${orderData['willingPrice']}'),
                Text('Total Price: ₹${orderData['quantity'] * orderData['willingPrice']}'),
                Text('Order Date: ${orderData['createdAt'].toDate()}'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        await updateOrderStatus('Confirmed');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Confirmed')));
                      },
                      child: Text('Confirm Order',
                        style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        await updateOrderStatus('Rejected');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Rejected')));
                      },
                      child: Text('Reject Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}