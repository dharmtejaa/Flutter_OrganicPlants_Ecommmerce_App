import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/plant_filter_service.dart';
import 'package:organicplants/core/theme/app_shadows.dart';

class ActiveFiltersWidget extends StatelessWidget {
  final Map<FilterType, dynamic> currentFilters;
  final int plantCount;
  final VoidCallback onClearAll;
  final bool showPlantCount;
  final RangeValues? originalPriceRange;

  const ActiveFiltersWidget({
    super.key,
    required this.currentFilters,
    required this.plantCount,
    required this.onClearAll,
    this.showPlantCount = true,
    this.originalPriceRange,
  });

  // Memoized computation of active filters
  List<Map<String, dynamic>> _getActiveFilters() {
    final activeFilters = <Map<String, dynamic>>[];

    if (currentFilters.containsKey(FilterType.sort)) {
      final sortOption = currentFilters[FilterType.sort] as String;
      if (sortOption != 'Name A-Z') {
        activeFilters.add({
          'label': 'Sort',
          'value': sortOption,
          'icon': Icons.sort,
        });
      }
    }

    if (currentFilters.containsKey(FilterType.price)) {
      final priceRange = currentFilters[FilterType.price] as RangeValues;
      // Only show price filter if it's different from the original range
      final isModified =
          originalPriceRange == null ||
          priceRange.start != originalPriceRange?.start ||
          priceRange.end != originalPriceRange?.end;
      if (isModified) {
        activeFilters.add({
          'label': 'Price',
          'value': '₹${priceRange.start.toInt()}-${priceRange.end.toInt()}',
          'icon': Icons.attach_money,
        });
      }
    }

    if (currentFilters.containsKey(FilterType.size)) {
      final size = currentFilters[FilterType.size] as String;
      if (size != 'All Sizes') {
        activeFilters.add({
          'label': 'Size',
          'value': size,
          'icon': Icons.height,
        });
      }
    }

    if (currentFilters.containsKey(FilterType.careLevel)) {
      final careLevel = currentFilters[FilterType.careLevel] as String;
      if (careLevel != 'All Levels') {
        activeFilters.add({
          'label': 'Care',
          'value': careLevel,
          'icon': Icons.lightbulb_outline,
        });
      }
    }

    if (currentFilters.containsKey(FilterType.attributes)) {
      final attributes = currentFilters[FilterType.attributes] as List<String>;
      if (attributes.isNotEmpty) {
        // Show only first 2 attributes to save space
        final displayAttributes = attributes.take(2).toList();
        final displayText =
            displayAttributes.join(', ') +
            (attributes.length > 2 ? ' +${attributes.length - 2}' : '');
        activeFilters.add({
          'label': 'Attributes',
          'value': displayText,
          'icon': Icons.local_florist,
        });
      }
    }

    return activeFilters;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final activeFilters = _getActiveFilters();

    if (activeFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: AppSizes.paddingAllSm,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.18),
          width: 1.w,
        ),
        boxShadow: AppShadows.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with count and clear button
          Row(
            children: [
              if (showPlantCount) ...[
                // Plant count with icon
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    boxShadow: AppShadows.cardShadow(context),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_florist_sharp,
                        size: 10.h,
                        color: colorScheme.onPrimary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$plantCount plants',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
              // Clear all button
              GestureDetector(
                onTap: onClearAll,
                //borderRadius: BorderRadius.circular(8.r),
                child: Text(
                  'Clear All',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (activeFilters.isNotEmpty) ...[
            SizedBox(height: 6.h),
            // Filter chips in a more compact layout
            Wrap(
              spacing: 5.w,
              runSpacing: 4.h,
              children:
                  activeFilters
                      .map(
                        (filter) => _buildFilterChip(
                          filter,
                          colorScheme,
                          textTheme,
                          context,
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    Map<String, dynamic> filter,
    ColorScheme colorScheme,
    TextTheme textTheme,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),

        boxShadow: AppShadows.cardShadow(context),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              filter['icon'] as IconData,
              size: 10.h,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              '${filter['label']}: ${filter['value']}',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
