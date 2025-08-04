import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryModel {
  final String orderId;
  final String date;
  final String status;
  final String total;
  final List<OrderItemModel> items;
  final String deliveryAddress;
  final String? trackingNumber;
  final DateTime createdAt;

  OrderHistoryModel({
    required this.orderId,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
    required this.deliveryAddress,
    this.trackingNumber,
    required this.createdAt,
  });

  factory OrderHistoryModel.fromMap(Map<String, dynamic> map, String uid) {
    try {
      return OrderHistoryModel(
        orderId: map['orderId'] ?? '',
        date: map['date'] ?? '',
        status: map['status'] ?? 'Processing',
        total: map['total'] ?? '₹0',
        items:
            (map['items'] as List? ?? [])
                .map((item) => OrderItemModel.fromMap(item))
                .toList(),
        deliveryAddress: map['deliveryAddress'] ?? '',
        trackingNumber: map['trackingNumber'],
        createdAt:
            map['createdAt'] is Timestamp
                ? (map['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error parsing OrderHistoryModel from map: $e');
      debugPrint('Map data: $map');
      // Return a default item if parsing fails
      return OrderHistoryModel(
        orderId: map['orderId'] ?? '',
        date: map['date'] ?? '',
        status: map['status'] ?? 'Processing',
        total: map['total'] ?? '₹0',
        items: [],
        deliveryAddress: map['deliveryAddress'] ?? '',
        trackingNumber: map['trackingNumber'],
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
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  OrderHistoryModel copyWith({
    String? orderId,
    String? date,
    String? status,
    String? total,
    List<OrderItemModel>? items,
    String? deliveryAddress,
    String? trackingNumber,
    DateTime? createdAt,
  }) {
    return OrderHistoryModel(
      orderId: orderId ?? this.orderId,
      date: date ?? this.date,
      status: status ?? this.status,
      total: total ?? this.total,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OrderItemModel {
  final String name;
  final int quantity;
  final String price;
  final String? plantId;
  final String? imageUrl;

  OrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
    this.plantId,
    this.imageUrl,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
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

  OrderItemModel copyWith({
    String? name,
    int? quantity,
    String? price,
    String? plantId,
    String? imageUrl,
  }) {
    return OrderItemModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      plantId: plantId ?? this.plantId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
