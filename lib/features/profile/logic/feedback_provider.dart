import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organicplants/features/profile/data/feedback_model.dart';
import 'package:organicplants/shared/logic/user_profile_provider.dart';

class FeedbackProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _lastError;
  bool _isSubmitting = false;

  // Getters

  bool get isSubmitting => _isSubmitting;
  String? get lastError => _lastError;

  // Submit feedback
  Future<bool> submitFeedback({
    required String message,
    required UserProfileProvider userProfileProvider,
  }) async {
    if (!userProfileProvider.isAuthenticated) {
      _setError('You must be logged in to submit feedback');
      return false;
    }

    if (message.trim().isEmpty) {
      _setError('Message cannot be empty');
      return false;
    }

    try {
      _setSubmitting(true);
      _clearError();

      final user = userProfileProvider.currentUser;
      final userProfile = userProfileProvider.userProfile;

      if (user == null) {
        _setError('User not found');
        return false;
      }

      final feedback = FeedbackModel(
        id: '', // Will be set by Firestore
        userId: user.uid,
        userName: userProfile?.fullName ?? user.displayName ?? 'Plant Lover',
        userEmail: userProfile?.email ?? user.email ?? '',
        message: message.trim(),
        createdAt: DateTime.now(),
      );

      // Add to Firestore with user ID as document ID
      await _firestore
          .collection('feedback')
          .doc(user.uid)
          .set(feedback.toMap());

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to submit feedback: ${e.toString()}');
      return false;
    } finally {
      _setSubmitting(false);
    }
  }

  // Set submitting state
  void _setSubmitting(bool submitting) {
    _isSubmitting = submitting;
    notifyListeners();
  }

  // Set error state
  void _setError(String error) {
    _lastError = error;
    notifyListeners();
  }

  // Clear error state
  void _clearError() {
    _lastError = null;
    notifyListeners();
  }
}
