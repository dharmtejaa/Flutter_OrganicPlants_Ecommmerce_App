// ignore_for_file: deprecated_member_use, duplicate_ignore
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
import 'package:organicplants/features/auth/presentation/screens/loginscreen.dart';
import 'package:organicplants/features/profile/presentation/screens/personal_information_screen.dart';
import 'package:organicplants/shared/buttons/custombutton.dart';
import 'package:organicplants/shared/logic/user_profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Consumer<UserProfileProvider>(
      builder: (
        BuildContext context,
        UserProfileProvider userProfileProvider,
        Widget? child,
      ) {
        // Check if user is authenticated and profile exists
        if (!userProfileProvider.isAuthenticated ||
            userProfileProvider.userProfile == null) {
          return _buildLoadingOrErrorState(context, colorScheme, textTheme);
        }
        String userName = 'Nature Lover'; // Default value
        if (userProfileProvider.userProfile != null &&
            userProfileProvider.userProfile!.fullName.isNotEmpty) {
          final nameParts = userProfileProvider.userProfile!.fullName
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

        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 240.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 146, 241, 197),
                      Color.fromARGB(255, 35, 172, 101),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.r),
                    bottomRight: Radius.circular(40.r),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80.h,
              left: -50.w,
              child: _decorativeBlob(colorScheme.primary, 140),
            ),
            Positioned(
              top: 120.h,
              right: -40.w,
              child: _decorativeBlob(colorScheme.primary, 100),
            ),
            Positioned(
              top: 30.h,
              right: 60.w,
              child: _decorativeBlob(colorScheme.primary, 60),
            ),
            // Enhanced decorative elements with theme-aware colors
            Column(
              children: [
                SizedBox(height: 60.h),
                // Enhanced Avatar with theme-aware styling
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.cardShadow(context),
                        ),
                        child: CircleAvatar(
                          radius: 55.r,
                          backgroundColor: colorScheme.surface,
                          child:
                              userProfileProvider
                                      .userProfile!
                                      .profileImageUrl
                                      .isNotEmpty
                                  ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          userProfileProvider
                                              .userProfile!
                                              .profileImageUrl,
                                      cacheManager:
                                          MyCustomCacheManager.instance,
                                      height: 110.h,
                                      width: 110.w,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => Container(
                                            height: 110.h,
                                            width: 110.w,
                                            color:
                                                colorScheme
                                                    .surfaceContainerHighest,
                                            child: Icon(
                                              Icons.person,
                                              size: 50.r,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                    ),
                                  )
                                  : Container(
                                    height: 110.h,
                                    width: 110.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 50.r,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PersonalInformationScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(06.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.surface,
                              boxShadow: AppShadows.cardShadow(context),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: colorScheme.primary,
                              size: AppSizes.iconMd,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Enhanced User Info Card with theme-aware colors
                Padding(
                  padding: AppSizes.paddingAllSm,
                  child: Container(
                    width: double.infinity,
                    padding: AppSizes.paddingAllXl,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                      boxShadow: AppShadows.cardShadow(context),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Hi, ${userName.toString()}',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          'Nature is not a place to visit. It is home.',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingOrErrorState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 240.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 146, 241, 197),
                  Color.fromARGB(255, 35, 172, 101),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(height: 60.h),
            Center(
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.cardShadow(context),
                ),
                child: CircleAvatar(
                  radius: 55.r,
                  backgroundColor: colorScheme.surface,
                  child: Container(
                    height: 110.h,
                    width: 110.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50.r,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: AppSizes.paddingAllSm,
              child: Container(
                width: double.infinity,
                padding: AppSizes.paddingAllXl,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                  boxShadow: AppShadows.cardShadow(context),
                ),
                child: Column(
                  children: [
                    Text(
                      'In every walk with nature, one receives far more than he seeks.',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: 10.h),
                    CustomButton(
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Loginscreen(),
                          ),
                        );
                      },
                      backgroundColor: colorScheme.primary,
                      textColor: colorScheme.onPrimary,
                      text: 'Login',
                      height: 30.h,
                      width: 80.w,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _decorativeBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // ignore: deprecated_member_use
        color: color.withOpacity(0.15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.2),
            blurRadius: 20.r,
            spreadRadius: 5.r,
          ),
        ],
      ),
    );
  }
}
