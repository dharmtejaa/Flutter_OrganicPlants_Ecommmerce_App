import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
import 'package:organicplants/features/store/presentation/screen/store_screen.dart';
import 'package:organicplants/shared/widgets/plantcategory.dart';

class SearchByCategory extends StatefulWidget {
  const SearchByCategory({super.key});

  @override
  State<SearchByCategory> createState() => _SearchByCategoryState();
}

class _SearchByCategoryState extends State<SearchByCategory> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: AppSizes.paddingSymmetricXs,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          color: colorScheme.surface,
          boxShadow: AppShadows.cardShadow(context),
        ),
        padding: EdgeInsets.only(left: 10.w, right: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 15.h),
              child: _buildModernHeader(context, colorScheme, textTheme),
            ),
            SizedBox(height: 10.h),
            // New horizontal scroll layout with small icon buttons
            SizedBox(
              height: 105.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(width: 15.w),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PlantCategory(
                                    plant: getPlantsByCategory(
                                      categories[index]['filterTag']!
                                          .toLowerCase()
                                          .trim(),
                                    ),
                                    category: categories[index]['title']!,
                                  ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: category['imagePath']!,
                          width: 70.w,
                          height: 70.w,
                          fit: BoxFit.cover,
                          cacheManager: MyCustomCacheManager.instance,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        //width: 70.w,
                        child: Text(
                          category['title']!,
                          textAlign: TextAlign.center,
                          style: textTheme.labelMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      //SizedBox(height: 5.h),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Browse by Category', style: textTheme.headlineMedium),
            // SizedBox(height: 4.h),
            // Text('Find plants for every mood', style: textTheme.titleMedium),
          ],
        ),
        InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StoreScreen()),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            ),
            child: Row(
              children: [
                Text(
                  'View All',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primaryFixed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: AppSizes.iconXs,
                  color: colorScheme.primaryFixed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
