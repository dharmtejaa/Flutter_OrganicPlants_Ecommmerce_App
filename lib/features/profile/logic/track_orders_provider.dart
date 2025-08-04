import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organicplants/features/profile/data/track_order_model.dart';

class TrackOrdersProvider with ChangeNotifier {
  final List<TrackOrderModel> _trackOrders = [];
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _trackOrdersListener;

  // Getters
  List<TrackOrderModel> get trackOrders => _trackOrders;
  String get _uid => _auth.currentUser?.uid ?? '';

  TrackOrdersProvider() {
    _initializeAuthListener();
  }

  // Listens for login/logout events to manage the track orders state.
  void _initializeAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      _disposeListener();
      if (user != null) {
        // User has logged in - merge guest track orders with Firestore
        _mergeGuestTrackOrdersWithFirestore(user.uid);
      } else {
        // User has logged out, clear the track orders for a new guest session
        _trackOrders.clear();
        notifyListeners();
      }
    });
  }

  // Merges in-memory guest track orders with the user's Firestore track orders upon login.
  Future<void> _mergeGuestTrackOrdersWithFirestore(String uid) async {
    if (_trackOrders.isEmpty) {
      // No guest track orders to merge, just load the Firestore track orders.
      _loadTrackOrdersFromFirestore(uid);
      return;
    }

    // A temporary copy of guest track orders to be merged.
    final List<TrackOrderModel> guestTrackOrdersToMerge = List.from(
      _trackOrders,
    );
    _trackOrders.clear(); // Clear local state before loading from Firestore

    final trackOrdersRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('track_orders');
    final batch = _firestore.batch();

    for (final guestTrackOrder in guestTrackOrdersToMerge) {
      final docRef = trackOrdersRef.doc(guestTrackOrder.orderId);
      // Use set with merge to add new track orders or update if they already exist.
      batch.set(docRef, guestTrackOrder.toMap(), SetOptions(merge: true));
    }

    try {
      await batch.commit();
    } catch (e) {
      debugPrint("Error merging guest track orders with Firestore: $e");
    } finally {
      // Whether merge succeeds or fails, load the definitive state from Firestore.
      _loadTrackOrdersFromFirestore(uid);
    }
  }

  // Sets up a real-time stream to the user's track orders.
  void _loadTrackOrdersFromFirestore(String uid) {
    _trackOrdersListener = _firestore
        .collection('users')
        .doc(uid)
        .collection('track_orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            _trackOrders.clear();
            for (var doc in snapshot.docs) {
              _trackOrders.add(TrackOrderModel.fromMap(doc.data(), uid));
            }
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Error listening to track orders: $error');
          },
        );
  }

  // Add a new track order (for both guest and logged-in users)
  Future<void> addTrackOrder(TrackOrderModel trackOrder) async {
    // Add to local list first for immediate UI update.
    _trackOrders.insert(0, trackOrder);

    // If the user is logged in, also save to Firestore.
    if (_uid.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('track_orders')
            .doc(trackOrder.orderId)
            .set(trackOrder.toMap());
      } catch (e) {
        debugPrint('Error adding to Firestore: $e');
        _trackOrders.removeWhere(
          (item) => item.orderId == trackOrder.orderId,
        ); // Rollback on error
      }
    }
    notifyListeners();
  }

  // Update track order status and progress
  Future<void> updateTrackOrderStatus(
    String orderId,
    String newStatus,
    double progress,
  ) async {
    final index = _trackOrders.indexWhere(
      (trackOrder) => trackOrder.orderId == orderId,
    );
    if (index == -1) return;

    final updatedTrackOrder = _trackOrders[index].copyWith(
      status: newStatus,
      progress: progress,
    );
    _trackOrders[index] = updatedTrackOrder;

    // If the user is logged in, also update Firestore.
    if (_uid.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('track_orders')
            .doc(orderId)
            .update({'status': newStatus, 'progress': progress});
      } catch (e) {
        debugPrint('Error updating in Firestore: $e');
      }
    }
    notifyListeners();
  }

  // Get track orders by status
  List<TrackOrderModel> getTrackOrdersByStatus(String status) {
    if (status == 'All') {
      return _trackOrders;
    }
    return _trackOrders
        .where((trackOrder) => trackOrder.status == status)
        .toList();
  }

  // Get track order by ID
  TrackOrderModel? getTrackOrderById(String orderId) {
    try {
      return _trackOrders.firstWhere(
        (trackOrder) => trackOrder.orderId == orderId,
      );
    } catch (e) {
      return null;
    }
  }

  // Helper method to create track order from order history
  TrackOrderModel createTrackOrderFromOrder({
    required String orderId,
    required String date,
    required String status,
    required String total,
    required List<Map<String, dynamic>> items,
    required String deliveryAddress,
    String? trackingNumber,
    String? estimatedDelivery,
    String? currentLocation,
    double progress = 0.0,
  }) {
    final trackItems =
        items
            .map(
              (item) => TrackOrderItemModel(
                name: item['name'] ?? '',
                quantity: item['quantity'] ?? 0,
                price: item['price'] ?? '₹0',
                plantId: item['plantId'],
                imageUrl: item['imageUrl'],
              ),
            )
            .toList();

    return TrackOrderModel(
      orderId: orderId,
      date: date,
      status: status,
      total: total,
      items: trackItems,
      deliveryAddress: deliveryAddress,
      trackingNumber: trackingNumber,
      estimatedDelivery: estimatedDelivery,
      currentLocation: currentLocation,
      progress: progress,
      createdAt: DateTime.now(),
    );
  }

  void _disposeListener() {
    _trackOrdersListener?.cancel();
    _trackOrdersListener = null;
  }

  @override
  void dispose() {
    _disposeListener();
    super.dispose();
  }
}
