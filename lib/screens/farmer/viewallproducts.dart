import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerProductsPage extends StatelessWidget {
  final String farmerId; // Farmer's user ID

  FarmerProductsPage({required this.farmerId});

  // Function to delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(farmerId)
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('My Products')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(farmerId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Farmer not found.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          // Check if the user is a farmer
          if (userData['userType'] != 'Farmer') {
            return Center(child: Text('No products found.'));
          }

          // Stream to fetch products from the farmer's products sub-collection
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(farmerId)
                .collection('products')
                .snapshots(),
            builder: (context, productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!productSnapshot.hasData || productSnapshot.data!.docs.isEmpty) {
                return Center(child: Text('No products found.'));
              }

              var products = productSnapshot.data!.docs;

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var productDoc = products[index];
                  var productData = productDoc.data() as Map<String, dynamic>;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text('Product: ${productData['productName'] ?? 'No Name'}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: ${productData['quantity']} kg'),
                          Text('Price per kg: ₹${productData['price']}'),
                          Text('Description: ${productData['description'] ?? 'No Description'}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Confirm delete action
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Product'),
                              content: Text('Are you sure you want to delete this product?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteProduct(productDoc.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
