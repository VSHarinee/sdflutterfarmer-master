// File: product.dart

class Product {
  final String name;
  final double price;
  final int quantity;
  final String farmerId;
  final String farmerName;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.farmerId,
    required this.farmerName,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String farmerId, String farmerName) {
    return Product(
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      farmerId: farmerId,
      farmerName: farmerName,
    );
  }
}
