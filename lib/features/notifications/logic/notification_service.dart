import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/notifications/logic/notification_provider.dart';
import 'package:organicplants/features/notifications/presentation/screens/notification_screen.dart';
import 'package:organicplants/features/splash/presentation/screens/splashscreen.dart';
import 'package:organicplants/shared/buttons/custombutton.dart';
import 'package:provider/provider.dart';
import 'package:organicplants/shared/logic/user_profile_provider.dart';

// Global navigator key to access context from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService extends StatefulWidget {
  final Widget child;

  const NotificationService({super.key, required this.child});

  @override
  State<NotificationService> createState() => _NotificationServiceState();

  /// Static method to initialize notification service
  static Future<void> initialize() async {
    final instance = _NotificationServiceState();
    await instance.initialize();
  }
}

class _NotificationServiceState extends State<NotificationService> {
  bool _isInitialized = false; // Add flag to prevent duplicate initialization

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return; // Prevent duplicate initialization

    _isInitialized = true;

    // Request permission
    await _requestPermission();
    // Setup Firebase messaging
    await _setupFirebaseMessaging();
  }

  /// Request notification permission
  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Setup Firebase messaging
  Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get FCM token and update user profile
    String? token = await messaging.getToken();
    if (token != null) {
      _updateUserFCMToken(token);
    }

    // Foreground messages (when app is open)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Save notification to Firestore using the global provider
      _saveNotificationToFirestore(
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
      );
      // Show dialog when app is open using navigator key
      _showNotificationDialog(
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
      );
    });

    // Background messages (when app is opened from notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Save notification to Firestore
      _saveNotificationToFirestore(
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
      );
      if (context.mounted) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        );
      }
    });

    //app is closed or is in terminate state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // Save notification to Firestore
        _saveNotificationToFirestore(
          message.notification?.title ?? 'No Title',
          message.notification?.body ?? 'No Body',
        );
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Splashscreen()),
        );
      }
    });
  }

  /// Update FCM token in user profile
  void _updateUserFCMToken(String token) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      final userProfileProvider = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );
      userProfileProvider.updateFCMToken(token);
    }
  }

  /// Save notification to Firestore
  void _saveNotificationToFirestore(String title, String body) {
    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    // Get the provider from the global context
    final context = navigatorKey.currentContext;
    if (context != null) {
      final provider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      provider.saveNotification(title, body);
    }
  }

  /// Show notification dialog using navigator key
  void _showNotificationDialog(String title, String body) {
    final context = navigatorKey.currentContext;
    final colorScheme = Theme.of(context!).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              elevation: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Banner header with gradient
                  Container(
                    padding: AppSizes.paddingAllMd,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.radiusLg),
                        topRight: Radius.circular(AppSizes.radiusLg),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          size: AppSizes.iconMd,
                          color: colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'New Notification',
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            color: colorScheme.onPrimary,
                            size: AppSizes.iconMd,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content section
                  Padding(
                    padding: AppSizes.paddingAllMd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          title,
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Body
                        Text(
                          body,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: AppSizes.paddingAllSm,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusSm,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Dismiss',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomButton(
                                height: 40.sp,
                                width: 40.sp,
                                backgroundColor: colorScheme.primary,
                                ontap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const NotificationScreen(),
                                    ),
                                  );
                                },
                                text: 'View Details',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
