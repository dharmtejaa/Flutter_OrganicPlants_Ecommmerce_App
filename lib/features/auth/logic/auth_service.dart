// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:organicplants/features/entry/presentation/screen/entry_screen.dart';
import 'package:organicplants/features/profile/data/user_profile_model.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:organicplants/shared/widgets/custom_dialog.dart';

class AuthService {
  // Login with email and password
  static Future<void> loginWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => EntryScreen()),
      );
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.showError(context, e.message.toString());
    }
  }

  // Sign up with email and password
  static Future<void> signUpWithEmailAndPassword(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      final uid = credential.user?.uid;

      if (uid != null) {
        // Get FCM token for the new user
        String? fcmToken;
        try {
          fcmToken = await FirebaseMessaging.instance.getToken();
        } catch (e) {
          debugPrint('Error getting FCM token during signup: $e');
        }

        final newUser = UserProfileModel(
          uid: uid,
          fullName: name,
          email: email,
          fcmToken: fcmToken ?? '',
          profileImageUrl:
              'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753501304/Sprout_head_empty_pfp_eakz4j.jpg',
          createdAt: DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(newUser.toMap());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EntryScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.showError(context, e.message.toString());
    }
  }

  // Sign in with Google
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EntryScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.showError(context, e.message.toString());
    } catch (e) {
      CustomSnackBar.showError(
        context,
        "An error occurred during Google sign-in.",
      );
    }
  }

  // Sign out user
  static Future<void> signOut(BuildContext context) async {
    try {
      final shouldSignOut = await CustomDialog.showConfirmation(
        context: context,
        title: "Sign Out",
        content: "Are you sure you want to sign out?",
        confirmText: "Yes, Sign Out",
        cancelText: "Cancel",
        icon: Icons.logout,
      );

      if (shouldSignOut == true) {
        // Sign out from Google if user signed in with Google
        final GoogleSignIn googleSignIn = GoogleSignIn.instance;
        await googleSignIn.signOut();

        // Sign out from Firebase Auth
        await FirebaseAuth.instance.signOut();

        CustomSnackBar.showSuccess(context, "Signed out successfully!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EntryScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.showError(context, "Failed to sign out: ${e.message}");
    } catch (e) {
      CustomSnackBar.showError(context, "An error occurred: ${e.toString()}");
    }
  }

  // *** REWRITTEN CLIENT-SIDE DELETE ACCOUNT FUNCTION ***
  static Future<void> deleteAccount(
    BuildContext context, {
    String? password,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnackBar.showError(context, "No user is currently signed in.");
      return;
    }

    // Check if user signed in with Google or email/password
    final isGoogleUser = user.providerData.any((profile) => profile.providerId == 'google.com');
    final isEmailUser = user.providerData.any((profile) => profile.providerId == 'password');

    // 1. Re-authenticate only if user signed in with email/password
    if (isEmailUser) {
      if (password == null || password.isEmpty) {
        CustomSnackBar.showError(context, "Password is required for email/password users.");
        return;
      }
      
      final bool reauthenticated = await reAuthenticateUser(
        context,
        email: user.email!,
        password: password,
      );
      if (!reauthenticated) return; // Stop if re-authentication fails.
    }

    // 2. Get final confirmation from the user.
    final confirmed = await CustomDialog.showConfirmation(
      // ignore: use_build_context_synchronously
      context: context,
      title: "Delete Account",
      content: isGoogleUser 
          ? "Are you sure you want to delete your account? This will permanently remove your account and all associated data. This action cannot be undone."
          : "This will permanently delete your account and all associated data. This action cannot be undone.",
      confirmText: "Delete Forever",
      cancelText: "Cancel",
      icon: Icons.warning_amber_rounded,
      // ignore: use_build_context_synchronously
      iconColor: Theme.of(context).colorScheme.error,
    );
    if (confirmed != true) return;

    try {
      // 3. Manually delete all user data from Firestore first.
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      // Delete known subcollections
      await _deleteCollection(userRef.collection('cart'));
      await _deleteCollection(userRef.collection('wishlist'));
      await _deleteCollection(userRef.collection('search_history'));
      // Add any other subcollections you have here

      // Delete the main user document
      await userRef.delete();

      // 4. Only after successful database deletion, delete the Auth user.
      await user.delete();
      
      // Sign out from Google if user signed in with Google
      if (isGoogleUser) {
        await GoogleSignIn.instance.signOut();
      }

      // ignore: use_build_context_synchronously
      CustomSnackBar.showSuccess(context, "Account deleted successfully!");
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => EntryScreen()),
      );
    } on FirebaseException catch (e) {
      // ignore: use_build_context_synchronously
      CustomSnackBar.showError(context, "Error during deletion: ${e.message}");
    } catch (e) {
      CustomSnackBar.showError(
        // ignore: use_build_context_synchronously
        context,
        "An unexpected error occurred: ${e.toString()}",
      );
    }
  }

  // Helper function to delete all documents in a collection
  static Future<void> _deleteCollection(CollectionReference collection) async {
    final snapshot =
        await collection.limit(500).get(); // Get documents in batches
    if (snapshot.docs.isEmpty) {
      return; // Collection is already empty
    }
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    // Recurse if there are more documents to delete
    if (snapshot.docs.length == 500) {
      await _deleteCollection(collection);
    }
  }

  // Re-authenticate user (required for sensitive operations like account deletion)
  static Future<bool> reAuthenticateUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return false;

      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password.trim(),
      );

      await currentUser.reauthenticateWithCredential(credential);
      CustomSnackBar.showSuccess(context, "Re-authentication successful!");
      return true;
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.showError(
        context,
        e.message ?? "Re-authentication failed",
      );
      return false;
    } catch (e) {
      CustomSnackBar.showError(context, "An error occurred: ${e.toString()}");
      return false;
    }
  }

  static Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      CustomSnackBar.showSuccess(context, "Password reset email sent!");
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // Debug logging
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      // Hide loading indicator
      Navigator.of(context).pop();
      CustomSnackBar.showError(context, e.message.toString());
      // Show detailed error dialog for debugging
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Email Not Sent"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.message.toString()),
                const SizedBox(height: 16),
                const Text("Troubleshooting tips:"),
                const SizedBox(height: 8),
                const Text("• Verify the email address is correct"),
                const Text("• Check your internet connection"),
                const Text("• Try again in a few minutes"),
                const Text("• Contact support if the problem persists"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Debug logging
      debugPrint('Unexpected error during password reset: $e');

      // Hide loading indicator
      Navigator.of(context).pop();

      CustomSnackBar.showError(
        context,
        "An unexpected error occurred: ${e.toString()}",
      );
    }
  }
}
