// lib/screens/farmer_details_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_status_page.dart';
import 'package:farm2fork/model/product_model.dart';

class FarmerDetailsPage extends StatefulWidget {
  final Product product;
  final String userId;
  FarmerDetailsPage({required this.product,required this.userId});

  @override
  _FarmerDetailsPageState createState() => _FarmerDetailsPageState();
}

class _FarmerDetailsPageState extends State<FarmerDetailsPage> {
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _willingPriceController = TextEditingController();
  double totalPrice = 0;

  // Calculate the total price based on quantity and willing price
  void _calculateTotalPrice() {
    setState(() {
      if (_quantityController.text.isNotEmpty && _willingPriceController.text.isNotEmpty) {
        double quantity = double.parse(_quantityController.text);
        double willingPrice = double.parse(_willingPriceController.text);
        totalPrice = quantity * willingPrice;
      }
    });
  }

  // Function to place an order
  Future<void> _placeOrder() async {
    if (_quantityController.text.isNotEmpty && _willingPriceController.text.isNotEmpty) {
      try {
        double quantity = double.parse(_quantityController.text);
        double willingPrice = double.parse(_willingPriceController.text);

        // Adding order details to Firestore
        await FirebaseFirestore.instance.collection('orders').add({
          'productId': widget.product.productId,
          'productName': widget.product.name,
          'quantity': quantity,
          'willingPrice': willingPrice,
          'totalPrice': totalPrice,
          'buyerId':widget.userId, // Replace with actual user ID
          'farmerId': widget.product.farmerId,
          'farmerName': widget.product.farmerName,
          'status': 'Pending',
          'createdAt': Timestamp.now(),
        });

        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order placed successfully!")),
        );

        // Navigate to the order status page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderStatusPage(
              product: widget.product,
              quantity: quantity,
              willingPrice: willingPrice,
                userId: widget.userId
            ),
          ),
        );
      } catch (e) {
        print("Error placing order: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to place order")),
        );
      }
    } else {
      // Show error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both quantity and bidding price")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Farmer Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product name and details
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
            SizedBox(height: 10),
            Text('Base Price: ₹${widget.product.price} per kg'),
            Text('Available Quantity: ${widget.product.quantity} kg'),
            SizedBox(height: 20),

            // Quantity input field
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Quantity (kg)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _calculateTotalPrice(),
            ),
            SizedBox(height: 10),

            // Willing price input field
            TextField(
              controller: _willingPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Your Willing Price (₹ per kg)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _calculateTotalPrice(),
            ),
            SizedBox(height: 20),

            // Display total price
            Text('Total Price: ₹${totalPrice.toStringAsFixed(2)}'),
            Spacer(),

            // Place order button
            Center(
              child: ElevatedButton(
                onPressed: _placeOrder,
                child: Text('Place Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
