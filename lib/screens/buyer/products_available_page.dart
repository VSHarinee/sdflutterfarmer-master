import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm2fork/model/product_model.dart'; // Import the correct Product model
import 'farmer_details_page.dart';

class ProductsAvailablePage extends StatefulWidget {
  final String userId;

  ProductsAvailablePage({required this.userId});

  @override
  _ProductsAvailablePageState createState() => _ProductsAvailablePageState();
}

class _ProductsAvailablePageState extends State<ProductsAvailablePage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductsFromAllFarmers();
  }

  // Fetch products for users where userType is 'Farmer'
  Future<void> _fetchProductsFromAllFarmers() async {
    try {
      final QuerySnapshot farmerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'Farmer')
          .get();

      List<Product> loadedProducts = [];

      for (var farmerDoc in farmerSnapshot.docs) {
        String farmerId = farmerDoc.id;
        String farmerName = farmerDoc['name'] ?? 'Unknown Farmer';

        // Fetch products from the 'products' subcollection of each farmer
        final QuerySnapshot productSnapshot = await farmerDoc.reference
            .collection('products')
            .get();

        for (var productDoc in productSnapshot.docs) {
          loadedProducts.add(
            Product.fromFirestore(productDoc.data() as Map<String, dynamic>, farmerId, farmerName),
          );
        }
      }

      setState(() {
        products = loadedProducts;
        filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to place an order for a product
  Future<void> _placeOrder(Product product) async {
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'productId': product.productId,
        'productName': product.name,
        'price': product.price,
        'quantity': 1, // Quantity can be user-specified
        'buyerId': widget.userId,
        'farmerId': product.farmerId,
        'farmerName': product.farmerName,
        'status': 'Pending',
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order placed successfully")),
      );
    } catch (e) {
      print("Error placing order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order")),
      );
    }
  }

  // Function to filter products based on search query
  void _filterProducts(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = products
          .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterProducts,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: Colors.green.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text("No products found"))
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    title: Text(
                      product.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Price: ₹${product.price} | Quantity: ${product.quantity} kg\nFarmer: ${product.farmerName}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _placeOrder(product);
                      },
                      child: Text('Place Order'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmerDetailsPage(product: product,userId: widget.userId),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
