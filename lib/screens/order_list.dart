import 'package:flutter/material.dart';


class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your Orders',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,  // Dummy count for now
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Order $index'),
                      subtitle: Text('Status: Pending'),
                      trailing: TextButton(
                        onPressed: () {
                          // Update order status (for farmers)
                        },
                        child: Text('Update Status'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
