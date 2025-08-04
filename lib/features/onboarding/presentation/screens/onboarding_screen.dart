import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/app_theme.dart';
import 'package:organicplants/core/theme/appcolors.dart';
import 'package:organicplants/features/auth/presentation/screens/loginscreen.dart';
import 'package:organicplants/features/home/logic/onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:organicplants/shared/widgets/gesture_detector_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Use Consumer for currentPage here to ensure AppBar reacts to changes
    // Alternatively, make onBoardingProvider in build listen: true
    // But for a single value in AppBar, a separate Consumer is cleaner.
    return Consumer<OnboardingProvider>(
      builder: (context, provider, child) {
        final currentPage =
            provider
                .currentPage; // Get current page from the provider being listened to
        final totalPages = onboardingData.length;
        return Scaffold(
          appBar: AppBar(
            actions: [
              currentPage <
                      totalPages -
                          1 // Use totalPages here for clarity
                  ? GestureDetectorButton(
                    textColor: AppTheme.primaryColor,
                    onPressed:
                        () => provider.skipToEnd(_controller, totalPages),
                  )
                  : SizedBox(),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        onPageChanged: (index) {
                          // This update triggers a rebuild of the Consumer above
                          Provider.of<OnboardingProvider>(
                            context,
                            listen: false,
                          ).updatePage(index);
                        },
                        controller: _controller,
                        itemCount: totalPages, // Use totalPages here
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //onbaording images
                              SizedBox(
                                height: AppSizes.onboardingImageHeight,
                                width: AppSizes.onboardingIamgeWidth,
                                child: Lottie.network(
                                  onboardingData[index]['image']!,
                                  repeat: true,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: AppSizes.spaceHeightMd),
                              //heading
                              Text(
                                onboardingData[index]['title']!,
                                textAlign: TextAlign.center,
                                style: textTheme.headlineLarge,
                              ),
                              SizedBox(height: 12.h),
                              //description
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.paddingMd,
                                ),
                                child: Text(
                                  onboardingData[index]['description']!,
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // The bottom Consumer is already listening correctly
                    Consumer<OnboardingProvider>(
                      builder: (context, provider, child) {
                        final currentPage =
                            provider
                                .currentPage; // Reactively gets current page
                        return Padding(
                          padding: AppSizes.paddingAllMd,
                          child: Row(
                            children: [
                              SmoothPageIndicator(
                                controller: _controller,
                                count: totalPages, // Use totalPages here
                                effect: ExpandingDotsEffect(
                                  dotColor: colorScheme.onSurfaceVariant,
                                  activeDotColor: colorScheme.primary,
                                  dotHeight: AppSizes.onboardingDotHeight,
                                  dotWidth: AppSizes.onboardingDotwidth,
                                  spacing: AppSizes.onboardingDotSpacing,
                                ),
                              ),
                              Flexible(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (currentPage < totalPages - 1) {
                                        // Use totalPages here
                                        provider.nextPage(
                                          _controller,
                                          totalPages, // Use totalPages here
                                        );
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => Loginscreen(),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSizes.paddingSm,
                                        vertical: AppSizes.paddingXs,
                                      ),

                                      //backgroundColor: colorScheme.primary,
                                      iconSize: AppSizes.fontMd,
                                      iconColor: AppColors.background,
                                      shape: StadiumBorder(),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        currentPage ==
                                                totalPages -
                                                    1 // Use totalPages here
                                            ? Text(
                                              'Get Started',
                                              style: textTheme.labelLarge,
                                            )
                                            : Text(
                                              'Next',
                                              style: textTheme.labelLarge,
                                            ),
                                        SizedBox(width: 4.w),
                                        Icon(
                                          currentPage == totalPages - 1
                                              ? Icons.login_rounded
                                              : Icons.arrow_forward_ios_rounded,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }, // End of the new Consumer
    );
  }
}
