// File: farmer_orders_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerOrdersPage extends StatelessWidget {
  final String farmerId; // Farmer's user ID

  FarmerOrdersPage({required this.farmerId});

  Future<void> _updateOrderStatus(String orderId, String newStatus, String buyerId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': newStatus,
      });

      String message = newStatus == "Accepted"
          ? "Your order has been accepted by the farmer."
          : "Your order has been rejected by the farmer.";

      await FirebaseFirestore.instance
          .collection('users')
          .doc(buyerId)
          .collection('notifications')
          .add({
        'message': message,
        'status': 'Unread',
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print("Error updating order status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Orders")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('farmerId', isEqualTo: farmerId)
            .where('status', isEqualTo: 'Pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text("Product: ${order['productId']}"),
                subtitle: Text("Quantity: ${order['quantity']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _updateOrderStatus(order.id, "Accepted", order['buyerId']);
                      },
                      child: Text("Accept"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _updateOrderStatus(order.id, "Rejected", order['buyerId']);
                      },
                      child: Text("Reject"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
