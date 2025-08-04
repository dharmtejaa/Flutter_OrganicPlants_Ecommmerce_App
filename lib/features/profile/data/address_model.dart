import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String fullName;
  final String phoneNumber;
  final String house;
  final String street;
  final String city;
  final String state;
  final String addressType;
  final DateTime addressId;

  AddressModel({
    required this.fullName,
    required this.phoneNumber,
    required this.house,
    required this.street,
    required this.city,
    required this.state,
    required this.addressType,
    required this.addressId,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map, String uid) {
    try {
      return AddressModel(
        fullName: map['fullName'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        house: map['house'] ?? '',
        street: map['street'] ?? '',
        city: map['city'] ?? '',
        state: map['state'] ?? '',
        addressType: map['addressType'] ?? 'Home',
        addressId:
            map['addressId'] is Timestamp
                ? (map['addressId'] as Timestamp).toDate()
                : DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error parsing AddressModel from map: $e');
      debugPrint('Map data: $map');
      // Return a default item if parsing fails
      return AddressModel(
        fullName: map['fullName'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        house: map['house'] ?? '',
        street: map['street'] ?? '',
        city: map['city'] ?? '',
        state: map['state'] ?? '',
        addressType: map['addressType'] ?? 'Home',
        addressId: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'house': house,
      'street': street,
      'city': city,
      'state': state,
      'addressType': addressType,
      'addressId': Timestamp.fromDate(addressId),
    };
  }

  AddressModel copyWith({
    String? fullName,
    String? phoneNumber,
    String? house,
    String? street,
    String? city,
    String? state,
    String? addressType,
    DateTime? addressId,
  }) {
    return AddressModel(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      house: house ?? this.house,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      addressType: addressType ?? this.addressType,
      addressId: addressId ?? this.addressId,
    );
  }
}
