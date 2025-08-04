import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organicplants/features/notifications/data/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async'; // Added for StreamSubscription

class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  StreamSubscription<QuerySnapshot>? _notificationsSubscription;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Initialize real-time listener
  void initializeNotifications() {
    final userId = _currentUserId;
    if (userId == null) {
      return;
    }

    _notificationsSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          _notifications =
              snapshot.docs
                  .map((doc) => NotificationModel.fromFirestore(doc))
                  .toList();
          notifyListeners();
        });
  }

  // Load notifications from Firestore (for one-time loading)
  Future<void> loadNotifications() async {
    final userId = _currentUserId;
    if (userId == null) {
      return;
    }

    _setLoading(true);
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .orderBy('timestamp', descending: true)
              .get();

      _notifications =
          snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Save notification to Firestore
  Future<void> saveNotification(String title, String body) async {
    final userId = _currentUserId;
    if (userId == null) {
      return;
    }

    try {
      final notification = NotificationModel(
        id: '', // Will be set by Firestore
        title: title,
        body: body,
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add(notification.toFirestore());
    } catch (e) {
      debugPrint('❌ Error saving notification: $e');
    }
  }

  // Delete individual notification
  Future<void> deleteNotification(String notificationId) async {
    final userId = _currentUserId;
    if (userId == null) {
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      debugPrint('❌ Error deleting notification: $e');
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    final userId = _currentUserId;
    if (userId == null) {
      return;
    }

    try {
      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      debugPrint('❌ Error clearing notifications: $e');
    }
  }

  // Private method
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationsSubscription?.cancel();
    _notificationsSubscription = null;
    super.dispose();
  }
}
