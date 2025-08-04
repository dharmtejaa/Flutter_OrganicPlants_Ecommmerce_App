// ignore_for_file: avoid_types_as_parameter_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/features/cart/data/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _cartItems = [];
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _cartListener;

  List<CartItemModel> get itemList => _cartItems;
  String get _uid => _auth.currentUser?.uid ?? '';

  CartProvider() {
    _initializeAuthListener();
  }

  // Listens for login/logout events to manage the cart state.
  void _initializeAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      _disposeListener(); // Always cancel the old listener

      if (user != null) {
        // User has logged in
        _mergeGuestCartWithFirestore(user.uid);
      } else {
        // User has logged out, clear the cart for a new guest session
        _cartItems.clear();
        notifyListeners();
      }
    });
  }

  // Merges in-memory guest cart with the user's Firestore cart upon login.
  Future<void> _mergeGuestCartWithFirestore(String uid) async {
    if (_cartItems.isEmpty) {
      // No guest cart to merge, just load the Firestore cart.
      loadCartFromFirestore(uid);
      return;
    }

    // A temporary copy of guest items to be merged.
    final List<CartItemModel> guestItemsToMerge = List.from(_cartItems);
    _cartItems.clear(); // Clear local state before loading from Firestore

    final cartRef = _firestore.collection('users').doc(uid).collection('cart');
    final batch = _firestore.batch();

    for (final guestItem in guestItemsToMerge) {
      final docRef = cartRef.doc(guestItem.plantId);
      // Use set with merge to add new items or update quantities if they already exist.
      batch.set(docRef, guestItem.toMap(), SetOptions(merge: true));
    }

    try {
      await batch.commit();
    } catch (e) {
      debugPrint("Error merging guest cart with Firestore: $e");
    } finally {
      // Whether merge succeeds or fails, load the definitive state from Firestore.
      loadCartFromFirestore(uid);
    }
  }

  // Sets up a real-time stream to the user's Firestore cart.
  void loadCartFromFirestore(String uid) {
    _cartListener = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots()
        .listen(
          (snapshot) {
            _cartItems.clear();
            for (var doc in snapshot.docs) {
              _cartItems.add(CartItemModel.fromMap(doc.data(), uid));
            }
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Error listening to cart: $error');
          },
        );
  }

  Future<void> addToCart(String plantId) async {
    final plant = AllPlantsGlobalData.getById(plantId);
    if (plant == null) return;

    final existingIndex = _cartItems.indexWhere(
      (item) => item.plantId == plantId,
    );

    if (existingIndex != -1) {
      // If item already exists, just increase its quantity.
      increaseQuantity(plantId);
      return;
    }

    // Create a new cart item.
    final originalPrice = plant.prices?.originalPrice ?? 0;
    final offerPrice = plant.prices?.offerPrice ?? 0;
    final discount =
        originalPrice > 0
            ? ((originalPrice - offerPrice) / originalPrice * 100)
            : 0;

    final cartItem = CartItemModel(
      plantId: plant.id ?? '',
      plantName: plant.commonName ?? 'Unknown Plant',
      imageUrl: plant.images?.firstOrNull?.url ?? '',
      originalPrice: originalPrice.toDouble(),
      offerPrice: offerPrice.toDouble(),
      discount: discount.toDouble(),
      rating: (plant.rating ?? 0).toDouble(),
      quantity: 1,
    );

    // Add to local list first for immediate UI update.
    _cartItems.add(cartItem);

    // If the user is logged in, also save to Firestore.
    if (_uid.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('cart')
            .doc(plantId)
            .set(cartItem.toMap());
      } catch (e) {
        debugPrint('Error adding to Firestore: $e');
        _cartItems.removeWhere(
          (item) => item.plantId == plantId,
        ); // Rollback on error
      }
    }
    notifyListeners();
  }

  Future<void> removeFromCart(String plantId) async {
    _cartItems.removeWhere((item) => item.plantId == plantId);

    if (_uid.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('cart')
          .doc(plantId)
          .delete();
    }
    notifyListeners();
  }

  Future<void> increaseQuantity(String plantId) async {
    final index = _cartItems.indexWhere((item) => item.plantId == plantId);
    if (index == -1) return;

    final updatedItem = _cartItems[index].copyWith(
      quantity: _cartItems[index].quantity + 1,
    );
    _cartItems[index] = updatedItem;

    if (_uid.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('cart')
          .doc(plantId)
          .update({'quantity': updatedItem.quantity});
    }
    notifyListeners();
  }

  Future<void> decreaseQuantity(String plantId) async {
    final index = _cartItems.indexWhere((item) => item.plantId == plantId);
    if (index == -1) return;

    // If quantity is 1, remove the item from cart
    if (_cartItems[index].quantity == 1) {
      await removeFromCart(plantId);
      return;
    }

    final updatedItem = _cartItems[index].copyWith(
      quantity: _cartItems[index].quantity - 1,
    );
    _cartItems[index] = updatedItem;

    if (_uid.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('cart')
          .doc(plantId)
          .update({'quantity': updatedItem.quantity});
    }
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear();

    if (_uid.isNotEmpty) {
      final cartRef = _firestore
          .collection('users')
          .doc(_uid)
          .collection('cart');
      final snapshot = await cartRef.get();
      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
    notifyListeners();
  }

  // --- Getters ---
  double get totalOriginalPrice => _cartItems.fold(
    0.0,
    (sum, item) => sum + item.originalPrice * item.quantity,
  );
  double get totalOfferPrice => _cartItems.fold(
    0.0,
    (sum, item) => sum + item.offerPrice * item.quantity,
  );
  double get totalDiscount => totalOriginalPrice - totalOfferPrice;
  int get cartItemsCount => _cartItems.length;
  bool isInCart(String? plantId) =>
      plantId != null && _cartItems.any((item) => item.plantId == plantId);

  CartItemModel? getCartItem(String plantId) {
    try {
      return _cartItems.firstWhere((item) => item.plantId == plantId);
    } catch (e) {
      return null;
    }
  }

  void _disposeListener() {
    _cartListener?.cancel();
    _cartListener = null;
  }

  @override
  void dispose() {
    _disposeListener();
    super.dispose();
  }
}
