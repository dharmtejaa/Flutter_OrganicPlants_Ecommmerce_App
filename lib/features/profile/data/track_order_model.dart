import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackOrderModel {
  final String orderId;
  final String date;
  final String status;
  final String total;
  final List<TrackOrderItemModel> items;
  final String deliveryAddress;
  final String? trackingNumber;
  final String? estimatedDelivery;
  final String? currentLocation;
  final double progress;
  final DateTime createdAt;

  TrackOrderModel({
    required this.orderId,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
    required this.deliveryAddress,
    this.trackingNumber,
    this.estimatedDelivery,
    this.currentLocation,
    required this.progress,
    required this.createdAt,
  });

  factory TrackOrderModel.fromMap(Map<String, dynamic> map, String uid) {
    try {
      return TrackOrderModel(
        orderId: map['orderId'] ?? '',
        date: map['date'] ?? '',
        status: map['status'] ?? 'Processing',
        total: map['total'] ?? '₹0',
        items:
            (map['items'] as List? ?? [])
                .map((item) => TrackOrderItemModel.fromMap(item))
                .toList(),
        deliveryAddress: map['deliveryAddress'] ?? '',
        trackingNumber: map['trackingNumber'],
        estimatedDelivery: map['estimatedDelivery'],
        currentLocation: map['currentLocation'],
        progress: (map['progress'] ?? 0.0).toDouble(),
        createdAt:
            map['createdAt'] is Timestamp
                ? (map['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error parsing TrackOrderModel from map: $e');
      debugPrint('Map data: $map');
      // Return a default item if parsing fails
      return TrackOrderModel(
        orderId: map['orderId'] ?? '',
        date: map['date'] ?? '',
        status: map['status'] ?? 'Processing',
        total: map['total'] ?? '₹0',
        items: [],
        deliveryAddress: map['deliveryAddress'] ?? '',
        trackingNumber: map['trackingNumber'],
        estimatedDelivery: map['estimatedDelivery'],
        currentLocation: map['currentLocation'],
        progress: 0.0,
        createdAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'date': date,
      'status': status,
      'total': total,
      'items': items.map((item) => item.toMap()).toList(),
      'deliveryAddress': deliveryAddress,
      'trackingNumber': trackingNumber,
      'estimatedDelivery': estimatedDelivery,
      'currentLocation': currentLocation,
      'progress': progress,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  TrackOrderModel copyWith({
    String? orderId,
    String? date,
    String? status,
    String? total,
    List<TrackOrderItemModel>? items,
    String? deliveryAddress,
    String? trackingNumber,
    String? estimatedDelivery,
    String? currentLocation,
    double? progress,
    DateTime? createdAt,
  }) {
    return TrackOrderModel(
      orderId: orderId ?? this.orderId,
      date: date ?? this.date,
      status: status ?? this.status,
      total: total ?? this.total,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      currentLocation: currentLocation ?? this.currentLocation,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TrackOrderItemModel {
  final String name;
  final int quantity;
  final String price;
  final String? plantId;
  final String? imageUrl;

  TrackOrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
    this.plantId,
    this.imageUrl,
  });

  factory TrackOrderItemModel.fromMap(Map<String, dynamic> map) {
    return TrackOrderItemModel(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? '₹0',
      plantId: map['plantId'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'plantId': plantId,
      'imageUrl': imageUrl,
    };
  }

  TrackOrderItemModel copyWith({
    String? name,
    int? quantity,
    String? price,
    String? plantId,
    String? imageUrl,
  }) {
    return TrackOrderItemModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      plantId: plantId ?? this.plantId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
