import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/shared/widgets/plantcategory.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AutoBannerWithNotifier extends StatefulWidget {
  const AutoBannerWithNotifier({super.key});

  @override
  State<AutoBannerWithNotifier> createState() => _AutoBannerWithNotifierState();
}

class _AutoBannerWithNotifierState extends State<AutoBannerWithNotifier> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  // ignore: override_on_non_overriding_member
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: banners.length,
          options: CarouselOptions(
            height: AppSizes.homeBannerHeight,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              _currentIndex.value = index;
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            return GestureDetector(
              onTap: () {
                // Navigate to the appropriate category based on the banner's filter tag
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PlantCategory(
                          plant: getPlantsByTag(
                            banner['filterTag']!.toLowerCase(),
                          ),
                          category: banner['title'] ?? 'Unknown',
                        ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: banner['imagePath']!,
                      fit: BoxFit.fill,
                      cacheManager: MyCustomCacheManager.instance,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            // ignore: deprecated_member_use
                            Colors.black.withOpacity(0.2),
                            // ignore: deprecated_member_use
                            Colors.black.withOpacity(0.2),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title with enhanced styling
                          Text(
                            banner['title']!,
                            style: textTheme.labelLarge,
                            maxLines: 1,
                          ),
                          SizedBox(height: 2.h),

                          // Subtitle with compact design
                          Text(
                            banner['subtitle']!,
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onPrimary,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //   bottom: 10,
                    //   right: 10,
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 10.w,
                    //       vertical: 5.h,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: colorScheme.primary,
                    //       borderRadius: BorderRadius.circular(
                    //         AppSizes.radiusMd,
                    //       ),
                    //     ),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Text(
                    //           'Explore',
                    //           style: textTheme.labelMedium?.copyWith(
                    //             color: colorScheme.onPrimary,
                    //           ),
                    //         ),
                    //         SizedBox(width: 2.w),
                    //         Icon(
                    //           Icons.arrow_forward_ios_rounded,
                    //           color: colorScheme.onPrimary,
                    //           size: AppSizes.iconsUxs,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    //banner text
                    // Positioned(
                    //   left: 14,
                    //   bottom: 14,
                    //   right: 14,
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // Text content on the left
                    //       Expanded(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             // Title with enhanced styling
                    //             Text(
                    //               banner['title']!,
                    //               style: textTheme.labelLarge,
                    //               maxLines: 1,
                    //             ),
                    //             SizedBox(height: 2.h),

                    //             // Subtitle with compact design
                    //             Text(
                    //               banner['subtitle']!,
                    //               style: textTheme.labelMedium?.copyWith(
                    //                 color: colorScheme.onPrimary,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),

                    //       SizedBox(width: 14.w),

                    //       // Compact Explore Button on the right
                    //       Container(
                    //         padding: EdgeInsets.symmetric(
                    //           horizontal: 8.w,
                    //           vertical: 4.h,
                    //         ),
                    //         decoration: BoxDecoration(
                    //           color: colorScheme.primary,
                    //           borderRadius: BorderRadius.circular(
                    //             AppSizes.radiusLg,
                    //           ),
                    //         ),
                    //         child: Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Text('Explore', style: textTheme.labelLarge),
                    //             SizedBox(width: 2.w),
                    //             Icon(
                    //               Icons.arrow_forward_ios_rounded,
                    //               color: colorScheme.onPrimary,
                    //               size: AppSizes.iconsUxs,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 5,
          child: ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder:
                (context, value, _) => AnimatedSmoothIndicator(
                  duration: Duration(milliseconds: 300),
                  activeIndex: _currentIndex.value,
                  count: banners.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8.sp,
                    dotWidth: 8.sp,
                    expansionFactor: 3,
                    // ignore: deprecated_member_use
                    dotColor: colorScheme.onPrimary.withOpacity(0.6),
                    // ignore: deprecated_member_use
                    activeDotColor: colorScheme.onPrimary,
                    spacing: 10,
                  ),
                  onDotClicked: (index) {
                    _carouselController.animateToPage(index);
                  },
                ),
          ),
        ),
      ],
    );
  }
}
