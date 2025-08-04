import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:organicplants/shared/widgets/productcard.dart';

class PlantSectionWidget extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  final List<AllPlantsModel> plants;

  const PlantSectionWidget({
    super.key,
    required this.title,
    required this.onSeeAll,
    required this.plants,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (plants.isEmpty) return const SizedBox.shrink();

    final List<AllPlantsModel> displayPlants = [...plants]..shuffle();

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
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 15.h),
              child: _buildModernHeader(
                context,
                colorScheme,
                textTheme,
                displayPlants,
              ),
            ),
            SizedBox(height: 10.h),
            // Product Cards List
            SizedBox(
              height: 241.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: displayPlants.length,
                separatorBuilder: (context, index) => SizedBox(width: 6.w),
                itemBuilder: (context, index) {
                  final plant = displayPlants[index];
                  return ProductCard(plantId: plant.id!);
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
    List<AllPlantsModel> displayPlants,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.headlineMedium),
            SizedBox(height: 4.h),
            Text(
              '${displayPlants.length} Plants available',
              style: textTheme.bodySmall,
            ),
          ],
        ),
        InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          onTap: onSeeAll,
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
