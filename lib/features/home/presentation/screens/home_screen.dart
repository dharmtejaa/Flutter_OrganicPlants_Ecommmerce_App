import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/features/home/presentation/widgets/auto_banner_with_notifier.dart';
import 'package:organicplants/features/home/presentation/widgets/search_by_category.dart';
import 'package:organicplants/features/notifications/presentation/screens/notification_screen.dart';
import 'package:organicplants/features/home/presentation/widgets/plant_section_widget.dart';
import 'package:organicplants/shared/logic/user_profile_provider.dart';
import 'package:organicplants/shared/widgets/custom_dialog.dart';
import 'package:organicplants/shared/widgets/plantcategory.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;

    // Ensure no focus is active when home screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return await CustomDialog.showConfirmation(
              context: context,
              title: "Are you sure?",
              content: "Do you want to exit the app?",
              confirmText: "Yes, Exit",
              cancelText: "No, Stay",
              icon: Icons.exit_to_app_outlined,
              iconColor: Theme.of(context).colorScheme.error,
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl:
                    'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753159417/app_logo2_itg7uy.png',
                height: 53.h,
                width: 53.w,
                color: colorScheme.primary,
                colorBlendMode: BlendMode.srcIn,
                cacheManager: MyCustomCacheManager.instance,
              ),
              //SizedBox(width: 5.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organic Plants',
                    style: textTheme.displaySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Consumer<UserProfileProvider>(
                    builder: (context, userProfileProvider, child) {
                      String userName = 'Nature Lover'; // Default value
                      if (userProfileProvider.userProfile != null &&
                          userProfileProvider
                              .userProfile!
                              .fullName
                              .isNotEmpty) {
                        final nameParts = userProfileProvider
                            .userProfile!
                            .fullName
                            .trim()
                            .split(' ');
                        if (nameParts.length >= 2) {
                          // Get the last name (last element in the array)
                          userName = nameParts.last;
                        } else {
                          // If only one name, use it as is
                          userName = nameParts.first;
                        }
                      } else {
                        userName = 'Nature Lover';
                      }
                      return Text(
                        '${getGreeting()}, $userName',
                        style: textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          actions: [
            if (isLoggedIn)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_none_rounded,
                  size: AppSizes.iconMd,
                  color: colorScheme.onSurface,
                ),
              ),
          ],
        ),

        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 10.h),
            AutoBannerWithNotifier(),
            SizedBox(height: 5.h),
            SearchByCategory(),
            //SizedBox(height: 5.h),
            PlantSectionWidget(
              title: "Air Purifying",
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PlantCategory(
                          plant: airPurifyingPlants,
                          category: "Air Purifying Plants",
                        ),
                  ),
                );
              },
              plants: airPurifyingPlants,
            ),
            PlantSectionWidget(
              title: "Low Maintenance",
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PlantCategory(
                          plant: lowMaintenancePlants,
                          category: "Low Maintenance Plants",
                        ),
                  ),
                );
              },
              plants: lowMaintenancePlants,
            ),
            PlantSectionWidget(
              title: "Pet Friendly",
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PlantCategory(
                          plant: petFriendlyPlants,
                          category: "Pet Friendly Plants",
                        ),
                  ),
                );
              },
              plants: petFriendlyPlants,
            ),
            PlantSectionWidget(
              title: "Sun Loving",
              onSeeAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PlantCategory(
                          plant: petFriendlyPlants,
                          category: "Sun Loving Plants",
                        ),
                  ),
                );
              },
              plants: sunLovingPlants,
            ),
          ],
        ),
      ),
    );
  }
}
