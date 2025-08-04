import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/services/plant_services.dart';
import 'package:organicplants/features/auth/presentation/screens/loginscreen.dart';
import 'package:organicplants/features/entry/presentation/screen/entry_screen.dart';
import 'package:organicplants/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Top-level ValueNotifier and timer for splash progress
final ValueNotifier<double> splashProgress = ValueNotifier(0.0);
bool _splashNavigated = false;

Future<void> loadSplashInitialData(BuildContext context) async {
  const totalSteps = 13; // Increased to include notification service
  int completedSteps = 0;

  void updateProgress() {
    completedSteps++;
    splashProgress.value = completedSteps / totalSteps;
  }

  try {
    updateProgress(); // 1
    allPlantsGlobal = await PlantServices.loadAllPlantsApi();
    AllPlantsGlobalData.initialize(allPlantsGlobal);

    updateProgress(); // 2
    indoorPlants = getPlantsByCategory('Indoor plant');

    updateProgress(); // 3
    outdoorPlants = getPlantsByCategory('Outdoor plant');

    updateProgress(); // 4
    medicinalPlants = getPlantsByCategory('Medicinal plant');

    updateProgress(); // 5
    herbsPlants = getPlantsByCategory('Herbs plant');

    updateProgress(); // 6
    floweringPlants = getPlantsByCategory('Flowering plant');

    updateProgress(); // 7
    bonsaiPlants = getPlantsByCategory('Bonsai plant');

    updateProgress(); // 8
    succulentsCactiPlants = getPlantsByCategory('Succulents & Cacti Plants');

    updateProgress(); // 9
    petFriendlyPlants = getPlantsByTag('Pet_Friendly');

    updateProgress(); // 10
    lowMaintenancePlants = getPlantsByTag('Low_Maintenance');

    updateProgress(); // 11
    airPurifyingPlants = getPlantsByTag('Air_Purifying');

    updateProgress(); // 12
    sunLovingPlants = getPlantsByTag('Sun_Loving');

    updateProgress(); // 13
    // Initialize notification service

    await Future.delayed(const Duration(milliseconds: 400));
  } catch (e) {
    debugPrint('Error loading data in Splashscreen: $e');
  } finally {
    splashProgress.value = 1.0;
    if (!_splashNavigated && context.mounted) {
      _splashNavigated = true;
      await _checkFirstLaunch(context);
    }
  }
}

Future<void> _checkFirstLaunch(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  const String launchKey = 'is_first_launch';
  final isFirstLaunch = prefs.getBool(launchKey) ?? true;

  await prefs.setBool(launchKey, false); // Always set after first check

  if (isFirstLaunch) {
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  } else {
    final user = FirebaseAuth.instance.currentUser;
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder:
            (_) => user != null ? const EntryScreen() : const Loginscreen(),
      ),
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    splashProgress.value = 0.0;
    _splashNavigated = false;
    loadSplashInitialData(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.marginSymmetricSm,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: AppSizes.paddingAllMd,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // ignore: deprecated_member_use
                        // ignore: deprecated_member_use
                        color: colorScheme.primaryContainer.withOpacity(0.2),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753159417/app_logo2_itg7uy.png',
                        height: 140.h,
                        width: 140.w,
                        cacheManager: MyCustomCacheManager.instance,
                        color: colorScheme.primary,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // App title with animation
                    Text(
                      'ORGANIC PLANTS',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineLarge?.copyWith(
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Progress bar
                    SizedBox(
                      width: 200.w,
                      child: ValueListenableBuilder<double>(
                        valueListenable: splashProgress,
                        builder: (context, value, child) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: value),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            builder: (context, animatedValue, _) {
                              return Column(
                                children: [
                                  LinearProgressIndicator(
                                    minHeight: 8.h,
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusMd,
                                    ),
                                    value: animatedValue,
                                    backgroundColor:
                                        colorScheme.surfaceContainerHighest,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    '${(animatedValue * 100).toInt()}%',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 160.h),
              // Developer credit
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Text(
                    "developed by: dharmtejaa",
                    style: textTheme.labelMedium?.copyWith(
                      // ignore: deprecated_member_use
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
