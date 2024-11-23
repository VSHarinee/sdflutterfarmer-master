import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final double price;
  final int quantity;

  ProductCard({required this.productName, required this.price, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(productName),
        subtitle: Text('Price: \$${price.toString()}, Quantity: $quantity'),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () {
            // Handle product order or addition to cart
          },
        ),
      ),
    );
  }
}
