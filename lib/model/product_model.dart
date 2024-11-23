class Product {
  final String productId;
  final String name;
  final double price;
  final double quantity;
  final String farmerId;
  final String farmerName;

  Product({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.farmerId,
    required this.farmerName,
  });

  // Factory constructor to create Product from Firestore document data
  factory Product.fromFirestore(Map<String, dynamic> data, String farmerId, String farmerName) {
    return Product(
      productId: data['productId'] ?? '',
      name: data['productName'] ?? 'Unnamed Product',
      price: (data['price'] ?? 0.0).toDouble(),
      quantity: (data['quantity'] ?? 0.0).toDouble(),
      farmerId: farmerId,
      farmerName: farmerName,
    );
  }
}
