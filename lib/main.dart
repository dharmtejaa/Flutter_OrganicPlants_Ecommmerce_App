import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/theme/app_theme.dart';
import 'package:organicplants/features/cart/logic/cart_provider.dart';
import 'package:organicplants/features/entry/logic/bottom_nav_provider.dart';
import 'package:organicplants/features/home/logic/onboarding_provider.dart';
import 'package:organicplants/features/product/logic/carousel_provider.dart';
import 'package:organicplants/features/profile/logic/address_provider.dart';
import 'package:organicplants/features/profile/logic/feedback_provider.dart';
import 'package:organicplants/features/profile/logic/order_history_provider.dart';
import 'package:organicplants/features/search/logic/hint_text_provider.dart';
import 'package:organicplants/features/search/logic/search_screen_provider.dart';
import 'package:organicplants/features/splash/presentation/screens/splashscreen.dart';
import 'package:organicplants/features/wishlist/logic/wishlist_provider.dart';
import 'package:organicplants/shared/logic/theme_provider.dart';
import 'package:organicplants/shared/logic/user_profile_provider.dart';
import 'package:organicplants/features/notifications/logic/notification_service.dart';
import 'package:organicplants/features/notifications/logic/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _backgroundMessaging(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBfbYeG53nOm2E0amp-XNe2SSuCdkiI8v8",
      appId: "1:662081729826:android:6db49ff6e6f8abaf37e17b",
      messagingSenderId: "662081729826",
      projectId: "organicplants143",
      storageBucket: "organicplants143.firebasestorage.app",
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_backgroundMessaging);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => SearchScreenProvider()),
        ChangeNotifierProvider(create: (_) => HintTextProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ), // Your ThemeProvider
        ChangeNotifierProvider(create: (_) => CarouselProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
        ChangeNotifierProvider(create: (_) => OrderHistoryProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design size for scaling
      minTextAdapt: true, // Enable text scaling
      splitScreenMode: true, // Enable split screen mode for better performance
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(
          context,
        ); // Get the theme provider
        return MaterialApp(
          navigatorKey: navigatorKey, // Add the navigator key here
          builder: (context, widget) {
            // 👇 Overrides global system font scaling
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: widget ?? const SizedBox.shrink(),
            );
          },
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme, // Your light theme
          darkTheme: AppTheme.darkTheme, // Your dark theme
          themeMode:
              themeProvider
                  .themeMode, // This will dynamically change based on provider
          home: const NotificationService(child: Splashscreen()),
        );
      },
    );
  }
}
