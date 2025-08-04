import 'package:flutter/material.dart';

class WishlistItemModel {
  final String plantId;
  final String plantName;
  final String imageUrl;
  final double originalPrice;
  final double offerPrice;
  final double discount;
  final double rating;
  final int quantity;

  WishlistItemModel({
    required this.plantId,
    required this.plantName,
    required this.imageUrl,
    required this.originalPrice,
    required this.offerPrice,
    required this.discount,
    required this.rating,
    required this.quantity,
  });

  // Add copyWith method for efficient updates
  WishlistItemModel copyWith({
    String? plantId,
    String? plantName,
    String? imageUrl,
    double? originalPrice,
    double? offerPrice,
    double? discount,
    double? rating,
    int? quantity,
  }) {
    return WishlistItemModel(
      plantId: plantId ?? this.plantId,
      plantName: plantName ?? this.plantName,
      imageUrl: imageUrl ?? this.imageUrl,
      originalPrice: originalPrice ?? this.originalPrice,
      offerPrice: offerPrice ?? this.offerPrice,
      discount: discount ?? this.discount,
      rating: rating ?? this.rating,
      quantity: quantity ?? this.quantity,
    );
  }

  factory WishlistItemModel.fromMap(Map<String, dynamic> map, String uid) {
    try {
      return WishlistItemModel(
        plantId: map['plantId'] ?? '',
        plantName: map['plantName'] ?? 'Unknown Plant',
        imageUrl: map['imageUrl'] ?? '',
        originalPrice: (map['originalPrice'] ?? 0).toDouble(),
        offerPrice: (map['offerPrice'] ?? 0).toDouble(),
        discount: (map['discount'] ?? 0).toDouble(),
        rating: (map['rating'] ?? 0).toDouble(),
        quantity: map['quantity'] ?? 1,
      );
    } catch (e) {
      debugPrint('Error parsing WishlistItemModel from map: $e');
      debugPrint('Map data: $map');
      // Return a default item if parsing fai ls
      return WishlistItemModel(
        plantId: map['plantId'] ?? '',
        plantName: map['plantName'] ?? 'Unknown Plant',
        imageUrl: map['imageUrl'] ?? '',
        originalPrice: 0.0,
        offerPrice: 0.0,
        discount: 0.0,
        rating: 0.0,
        quantity: 1,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'plantId': plantId,
      'plantName': plantName,
      'imageUrl': imageUrl,
      'originalPrice': originalPrice,
      'offerPrice': offerPrice,
      'discount': discount,
      'rating': rating,
      'quantity': quantity,
    };
  }
}
