import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/features/wishlist/data/wishlist_model.dart';

class WishlistProvider extends ChangeNotifier {
  // This list holds the wishlist items. It serves as the in-memory storage for guests
  // and is synchronized with Firestore for logged-in users.
  final List<WishlistItemModel> _wishlistItems = [];
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Real-time listener for Firestore changes.
  StreamSubscription<QuerySnapshot>? _wishlistListener;

  List<WishlistItemModel> get wishlistItems => _wishlistItems;
  String get _uid => _auth.currentUser?.uid ?? '';

  WishlistProvider() {
    // Listen for authentication state changes (login/logout).
    _auth.authStateChanges().listen((User? user) {
      _disposeListener(); // Always cancel any existing listener.

      if (user != null) {
        // --- USER LOGGED IN ---
        // 1. Merge the guest's in-memory wishlist with their Firestore wishlist.
        _mergeGuestWishlistWithFirestore(user.uid);
      } else {
        // --- USER LOGGED OUT (GUEST MODE) ---
        // 1. Clear the list to ensure a fresh guest session.
        _wishlistItems.clear();
        notifyListeners();
      }
    });
  }

  /// Merges the in-memory guest wishlist with the user's Firestore wishlist upon login.
  Future<void> _mergeGuestWishlistWithFirestore(String uid) async {
    // If the guest wishlist is empty, there's nothing to merge. Just load the user's online wishlist.
    if (_wishlistItems.isEmpty) {
      _loadWishlistFromFirestore(uid);
      return;
    }

    // Create a copy of the guest items to be merged.
    final List<WishlistItemModel> guestItemsToMerge = List.from(_wishlistItems);
    _wishlistItems
        .clear(); // Clear the local state to prepare for loading from Firestore.

    final wishlistRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('wishlist');
    final batch = _firestore.batch();

    // Add each guest item to a batch write. `SetOptions(merge: true)` ensures we don't overwrite existing items.
    for (final guestItem in guestItemsToMerge) {
      final docRef = wishlistRef.doc(guestItem.plantId);
      batch.set(docRef, guestItem.toMap(), SetOptions(merge: true));
    }

    try {
      // Commit the batch write to save all items at once.
      await batch.commit();
    } catch (e) {
      debugPrint("Error merging guest wishlist with Firestore: $e");
    } finally {
      // Regardless of merge success or failure, load the definitive state from Firestore.
      _loadWishlistFromFirestore(uid);
    }
  }

  /// Sets up a real-time stream to the logged-in user's Firestore wishlist.
  void _loadWishlistFromFirestore(String uid) {
    if (uid.isEmpty) return;

    _wishlistListener = _firestore
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .snapshots()
        .listen(
          (snapshot) {
            // Rebuild the local list from the latest Firestore data.
            _wishlistItems.clear();
            _wishlistItems.addAll(
              snapshot.docs.map(
                (doc) => WishlistItemModel.fromMap(doc.data(), uid),
              ),
            );
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Error listening to wishlist: $error');
          },
        );
  }

  /// Adds or removes a plant from the wishlist. Works for both guests and logged-in users.
  Future<void> toggleWishList(String plantId) async {
    final plant = AllPlantsGlobalData.getById(plantId);
    if (plant == null) return; // Exit if plant data is not found.

    final isAlreadyInWishlist = isInWishlist(plantId);

    if (isAlreadyInWishlist) {
      // --- REMOVE ITEM ---
      _wishlistItems.removeWhere((p) => p.plantId == plantId);
      // If user is logged in, also remove from Firestore.
      if (_uid.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('wishlist')
            .doc(plantId)
            .delete();
      }
    } else {
      // --- ADD ITEM ---
      final originalPrice = plant.prices?.originalPrice ?? 0;
      final offerPrice = plant.prices?.offerPrice ?? 0;
      final discount =
          originalPrice > 0
              ? ((originalPrice - offerPrice) / originalPrice * 100)
              : 0;

      final wishlistItem = WishlistItemModel(
        plantId: plant.id ?? '',
        plantName: plant.commonName ?? 'Unknown Plant',
        imageUrl: plant.images?.firstOrNull?.url ?? '',
        originalPrice: originalPrice.toDouble(),
        offerPrice: offerPrice.toDouble(),
        discount: discount.toDouble(),
        rating: (plant.rating ?? 0).toDouble(),
        quantity: 1,
      );

      _wishlistItems.add(wishlistItem);
      // If user is logged in, also save to Firestore.
      if (_uid.isNotEmpty) {
        try {
          await _firestore
              .collection('users')
              .doc(_uid)
              .collection('wishlist')
              .doc(plantId)
              .set(wishlistItem.toMap());
        } catch (e) {
          debugPrint('Error saving to Firestore: $e');
          // Rollback: If Firestore save fails, remove from the local list to keep state consistent.
          _wishlistItems.removeWhere((item) => item.plantId == plantId);
        }
      }
    }
    // Notify all listening widgets to rebuild with the new wishlist state.
    notifyListeners();
  }

  // --- Helper Methods ---

  bool isInWishlist(String plantId) =>
      _wishlistItems.any((plant) => plant.plantId == plantId);

  WishlistItemModel? getWishlistItem(String plantId) {
    try {
      return _wishlistItems.firstWhere((item) => item.plantId == plantId);
    } catch (e) {
      return null;
    }
  }

  void _disposeListener() {
    _wishlistListener?.cancel();
    _wishlistListener = null;
  }

  @override
  void dispose() {
    _disposeListener();
    super.dispose();
  }
}
