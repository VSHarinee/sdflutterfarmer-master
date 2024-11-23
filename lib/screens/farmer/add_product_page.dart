import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatelessWidget {
  final String userId;

  AddProductPage({required this.userId});

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  // Function to add product to Firestore
  Future<void> _addProduct() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('products') // Creates a sub-collection of products under each user
          .add({
        'productName': productNameController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'quantity': int.tryParse(quantityController.text) ?? 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Product added successfully');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Add a Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add a Product',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await _addProduct();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Product added successfully')),
                );
                // Clear fields after submission
                productNameController.clear();
                priceController.clear();
                quantityController.clear();
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
