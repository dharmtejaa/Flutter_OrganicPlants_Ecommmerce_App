import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organicplants/features/profile/data/order_history_model.dart';

class OrderHistoryProvider with ChangeNotifier {
  final List<OrderHistoryModel> _orders = [];
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _ordersListener;

  // Getters
  List<OrderHistoryModel> get orders => _orders;
  String get _uid => _auth.currentUser?.uid ?? '';

  OrderHistoryProvider() {
    _initializeAuthListener();
  }

  // Listens for login/logout events to manage the orders state.
  void _initializeAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      _disposeListener();
      if (user != null) {
        // User has logged in - merge guest orders with Firestore
        _mergeGuestOrdersWithFirestore(user.uid);
      } else {
        // User has logged out, clear the orders for a new guest session
        _orders.clear();
        notifyListeners();
      }
    });
  }

  // Merges in-memory guest orders with the user's Firestore orders upon login.
  Future<void> _mergeGuestOrdersWithFirestore(String uid) async {
    if (_orders.isEmpty) {
      // No guest orders to merge, just load the Firestore orders.
      _loadOrdersFromFirestore(uid);
      return;
    }

    // A temporary copy of guest orders to be merged.
    final List<OrderHistoryModel> guestOrdersToMerge = List.from(_orders);
    _orders.clear(); // Clear local state before loading from Firestore

    final ordersRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('orders');
    final batch = _firestore.batch();

    for (final guestOrder in guestOrdersToMerge) {
      final docRef = ordersRef.doc(guestOrder.orderId);
      // Use set with merge to add new orders or update if they already exist.
      batch.set(docRef, guestOrder.toMap(), SetOptions(merge: true));
    }

    try {
      await batch.commit();
    } catch (e) {
      debugPrint("Error merging guest orders with Firestore: $e");
    } finally {
      // Whether merge succeeds or fails, load the definitive state from Firestore.
      _loadOrdersFromFirestore(uid);
    }
  }

  // Sets up a real-time stream to the user's orders.
  void _loadOrdersFromFirestore(String uid) {
    _ordersListener = _firestore
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            _orders.clear();
            for (var doc in snapshot.docs) {
              _orders.add(OrderHistoryModel.fromMap(doc.data(), uid));
            }
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Error listening to orders: $error');
          },
        );
  }

  // Add a new order (for both guest and logged-in users)
  Future<void> addOrder(OrderHistoryModel order) async {
    // Add to local list first for immediate UI update.
    _orders.insert(0, order);

    // If the user is logged in, also save to Firestore.
    if (_uid.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('orders')
            .doc(order.orderId)
            .set(order.toMap());
      } catch (e) {
        debugPrint('Error adding to Firestore: $e');
        _orders.removeWhere(
          (item) => item.orderId == order.orderId,
        ); // Rollback on error
      }
    }
    notifyListeners();
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final index = _orders.indexWhere((order) => order.orderId == orderId);
    if (index == -1) return;

    final updatedOrder = _orders[index].copyWith(status: newStatus);
    _orders[index] = updatedOrder;

    // If the user is logged in, also update Firestore.
    if (_uid.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('orders')
            .doc(orderId)
            .update({'status': newStatus});
      } catch (e) {
        debugPrint('Error updating in Firestore: $e');
      }
    }
    notifyListeners();
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, 'Cancelled');
  }

  // Get orders by status
  List<OrderHistoryModel> getOrdersByStatus(String status) {
    if (status == 'All') {
      return _orders;
    }
    return _orders.where((order) => order.status == status).toList();
  }

  // Get order by ID
  OrderHistoryModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.orderId == orderId);
    } catch (e) {
      return null;
    }
  }

  // Helper method to create order from cart items
  OrderHistoryModel createOrderFromCart({
    required List<Map<String, dynamic>> cartItems,
    required String deliveryAddress,
    required String total,
  }) {
    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
    final date = DateTime.now().toString().substring(0, 10);

    final items =
        cartItems
            .map(
              (item) => OrderItemModel(
                name: item['name'] ?? '',
                quantity: item['quantity'] ?? 0,
                price: item['price'] ?? '₹0',
                plantId: item['plantId'],
                imageUrl: item['imageUrl'],
              ),
            )
            .toList();

    return OrderHistoryModel(
      orderId: orderId,
      date: date,
      status: 'Processing',
      total: total,
      items: items,
      deliveryAddress: deliveryAddress,
      trackingNumber: null,
      createdAt: DateTime.now(),
    );
  }

  void _disposeListener() {
    _ordersListener?.cancel();
    _ordersListener = null;
  }

  @override
  void dispose() {
    _disposeListener();
    super.dispose();
  }
}
