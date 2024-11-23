// order_status_page.dart
import 'package:flutter/material.dart';
import 'package:farm2fork/model/product_model.dart';

import 'addconfpage.dart';

class OrderStatusPage extends StatelessWidget {
  final Product product;
  final double quantity;
  final double willingPrice;
  final String userId;
  OrderStatusPage({
    required this.product,
    required this.quantity,
    required this.willingPrice,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    double totalPrice = quantity * willingPrice;

    return Scaffold(
      appBar: AppBar(title: Text('Order Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Order Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Product: ${product.name}'),
            Text('Farmer: ${product.farmerName}'),
            Text('Quantity: ${quantity} kg'),
            Text('Bidding Price: ₹${willingPrice.toStringAsFixed(2)} per kg'),
            Text('Total Price: ₹${totalPrice.toStringAsFixed(2)}'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressVerificationPage(userId: userId),
                  ),
                );

                // Logic to handle order confirmation can be added here
              },
              child: Text('CONFORM ORDER'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
