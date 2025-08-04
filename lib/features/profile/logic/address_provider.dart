import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:organicplants/features/profile/data/address_model.dart';

class AddressProvider with ChangeNotifier {
  final List<AddressModel> _address = [];
  AddressModel? _selectedAddress;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _addressListener;

  //Getters
  List<AddressModel> get address => _address;
  AddressModel? get selectedAddress => _selectedAddress;
  String get _uid => _auth.currentUser?.uid ?? '';

  AddressProvider() {
    _initializeAddressListener();
  }

  // Set selected address
  void setSelectedAddress(AddressModel? address) {
    _selectedAddress = address;
    notifyListeners();
  }

  // Get default address or first address
  AddressModel? get defaultAddress {
    if (_address.isEmpty) return null;
    return _selectedAddress ?? _address.first;
  }

  // Listens for login/logout events to manage the address state.
  void _initializeAddressListener() {
    _auth.authStateChanges().listen((User? user) {
      _disposeListener();
      if (user != null) {
        // User has logged in - merge guest addresses with Firestore
        _mergeGuestAddressWithFirestore(user.uid);
      } else {
        // User has logged out, clear the addresses for a new guest session
        _address.clear();
        notifyListeners();
      }
    });
  }

  // Merges in-memory guest addresses with the user's Firestore addresses upon login.
  Future<void> _mergeGuestAddressWithFirestore(String uid) async {
    if (_address.isEmpty) {
      // No guest addresses to merge, just load the Firestore addresses.
      _loadAddressFromFirestore(uid);
      return;
    }

    // A temporary copy of guest addresses to be merged.
    final List<AddressModel> guestAddressesToMerge = List.from(_address);
    _address.clear(); // Clear local state before loading from Firestore

    final addressRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('address');
    final batch = _firestore.batch();

    for (final guestAddress in guestAddressesToMerge) {
      final docRef = addressRef.doc(guestAddress.addressId.toIso8601String());
      // Use set with merge to add new addresses or update if they already exist.
      batch.set(docRef, guestAddress.toMap(), SetOptions(merge: true));
    }

    try {
      await batch.commit();
    } catch (e) {
      debugPrint("Error merging guest addresses with Firestore: $e");
    } finally {
      // Whether merge succeeds or fails, load the definitive state from Firestore.
      _loadAddressFromFirestore(uid);
    }
  }

  // Sets up a real-time stream to the user's address.
  void _loadAddressFromFirestore(String uid) {
    _addressListener = _firestore
        .collection('users')
        .doc(uid)
        .collection('address')
        .snapshots()
        .listen(
          (snapshot) {
            _address.clear();
            for (var doc in snapshot.docs) {
              _address.add(AddressModel.fromMap(doc.data(), uid));
            }
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Error listening to address: $error');
          },
        );
  }

  Future<void> addAddress(
    String fullName,
    String phoneNumber,
    String house,
    String street,
    String city,
    String state,
    String addressType,
  ) async {
    final address = AddressModel(
      fullName: fullName,
      phoneNumber: phoneNumber,
      house: house,
      street: street,
      city: city,
      state: state,
      addressType: addressType,
      addressId: DateTime.now(),
    );

    // Add to local list first for immediate UI update.
    _address.add(address);

    // If the user is logged in, also save to Firestore.
    if (_uid.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('address')
            .doc(address.addressId.toIso8601String())
            .set(address.toMap());
      } catch (e) {
        debugPrint('Error adding to Firestore: $e');
        _address.removeWhere(
          (item) => item.addressId == address.addressId,
        ); // Rollback on error
      }
    }
    notifyListeners();
  }

  Future<void> updateAddress(
    DateTime addressId,
    String fullName,
    String phoneNumber,
    String house,
    String street,
    String city,
    String state,
    String addressType,
  ) async {
    final updatedAddress = AddressModel(
      fullName: fullName,
      phoneNumber: phoneNumber,
      house: house,
      street: street,
      city: city,
      state: state,
      addressType: addressType,
      addressId: addressId,
    );

    // Update local list
    final index = _address.indexWhere((item) => item.addressId == addressId);
    if (index != -1) {
      _address[index] = updatedAddress;
    }

    // If the user is logged in, also update Firestore.
    if (_uid.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(_uid)
            .collection('address')
            .doc(addressId.toIso8601String())
            .update(updatedAddress.toMap());
      } catch (e) {
        debugPrint('Error updating in Firestore: $e');
      }
    }
    notifyListeners();
  }

  Future<void> removeFromAddress(DateTime addressId) async {
    _address.removeWhere((item) => item.addressId == addressId);

    if (_uid.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('address')
          .doc(addressId.toIso8601String())
          .delete();
    }
    notifyListeners();
  }

  void _disposeListener() {
    _addressListener?.cancel();
    _addressListener = null;
  }

  @override
  void dispose() {
    _disposeListener();
    super.dispose();
  }
}
