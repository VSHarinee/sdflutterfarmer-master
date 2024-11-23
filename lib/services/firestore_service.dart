/*import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a product to Firestore (Farmers)
  Future<void> addProduct(String farmerId, String productName, double price, int quantity) async {
    try {
      await _db.collection('products').add({
        'farmerId': farmerId,
        'productName': productName,
        'price': price,
        'quantity': quantity,
        'createdAt': FieldValue.serverTimestamp(), // Timestamp for when the product was added
      });
      print('Product added successfully');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Fetch all products from Firestore (Buyers)
  Stream<List<Map<String, dynamic>>> getAllProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'farmerId': doc['farmerId'],
          'productName': doc['productName'],
          'price': doc['price'],
          'quantity': doc['quantity'],
        };
      }).toList();
    });
  }

  // Update product quantity after an order is placed (Farmers/Buyers)
  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    try {
      await _db.collection('products').doc(productId).update({
        'quantity': newQuantity,
      });
      print('Product quantity updated');
    } catch (e) {
      print('Error updating product quantity: $e');
    }
  }

  // Place an order (Buyers)
  Future<void> placeOrder(String buyerId, String productId, int quantity) async {
    try {
      await _db.collection('orders').add({
        'buyerId': buyerId,
        'productId': productId,
        'quantity': quantity,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Order placed successfully');
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  // Fetch orders for a farmer (Farmers)
  Stream<List<Map<String, dynamic>>> getOrdersForFarmer(String farmerId) {
    return _db.collection('orders')
        .where('farmerId', isEqualTo: farmerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'orderId': doc.id,
          'productId': doc['productId'],
          'quantity': doc['quantity'],
          'status': doc['status'],
        };
      }).toList();
    });
  }

  // Update order status (Farmers)
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
      print('Order status updated');
    } catch (e) {
      print('Error updating order status: $e');
    }
  }
}
*/