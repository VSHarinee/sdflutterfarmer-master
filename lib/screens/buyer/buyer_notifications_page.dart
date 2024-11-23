// File: buyer_notifications_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyerNotificationsPage extends StatelessWidget {
  final String buyerId;

  BuyerNotificationsPage({required this.buyerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Notifications")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(buyerId)
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification['message']),
                trailing: Icon(
                  notification['status'] == 'Unread' ? Icons.notifications : Icons.check,
                  color: notification['status'] == 'Unread' ? Colors.red : Colors.green,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
