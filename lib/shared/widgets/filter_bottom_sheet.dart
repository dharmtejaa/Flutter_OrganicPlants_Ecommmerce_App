import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/plant_filter_service.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:organicplants/core/theme/app_shadows.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<AllPlantsModel> plants;
  final Map<FilterType, dynamic> currentFilters;
  final List<FilterType> enabledFilters;
  final Function(Map<FilterType, dynamic>) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.plants,
    required this.currentFilters,
    required this.enabledFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Replace all local state variables with ValueNotifier
  final ValueNotifier<String> _selectedSort = ValueNotifier('Name A-Z');
  final ValueNotifier<String> _selectedSize = ValueNotifier('All Sizes');
  final ValueNotifier<String> _selectedCareLevel = ValueNotifier('All Levels');
  final ValueNotifier<Set<String>> _selectedAttributes = ValueNotifier(
    <String>{},
  );
  final ValueNotifier<bool> _inStockOnly = ValueNotifier(false);
  final ValueNotifier<RangeValues> _priceRange = ValueNotifier(
    RangeValues(0, 2000),
  );
  final ValueNotifier<RangeValues> _ratingRange = ValueNotifier(
    RangeValues(0.0, 5.0),
  );

  late double _minPrice;
  late double _maxPrice;

  final List<String> _sortOptions = [
    'Name A-Z',
    'Name Z-A',
    'Price Low to High',
    'Price High to Low',
    'Rating High to Low',
    'Most Popular',
    'Newest First',
  ];

  final List<String> _sizeOptions = [
    'All Sizes',
    'Small Plants',
    'Medium Plants',
    'Large Plants',
  ];

  final List<String> _careLevelOptions = [
    'All Levels',
    'Beginner Friendly',
    'Low Maintenance',
    'High Maintenance',
  ];

  final List<String> _attributeOptions = [
    'Pet Friendly',
    'Air Purifying',
    'Low Maintenance',
    'Sun Loving',
    'Shade Loving',
    'Drought Tolerant',
    'Flowering',
    'Non-Flowering',
    'Beginner Friendly',
    'High Maintenance',
  ];

  @override
  void initState() {
    super.initState();
    _initializeFilters();
    _calculatePriceRange();
  }

  @override
  void dispose() {
    _selectedSort.dispose();
    _selectedSize.dispose();
    _selectedCareLevel.dispose();
    _selectedAttributes.dispose();
    _inStockOnly.dispose();
    _priceRange.dispose();
    _ratingRange.dispose();
    super.dispose();
  }

  void _initializeFilters() {
    _selectedSort.value = widget.currentFilters[FilterType.sort] ?? 'Name A-Z';
    _selectedSize.value = widget.currentFilters[FilterType.size] ?? 'All Sizes';
    _selectedCareLevel.value =
        widget.currentFilters[FilterType.careLevel] ?? 'All Levels';
    _selectedAttributes.value = Set<String>.from(
      widget.currentFilters[FilterType.attributes] ?? [],
    );
    _inStockOnly.value = widget.currentFilters[FilterType.stock] ?? false;

    // Price range
    final priceRange = widget.currentFilters[FilterType.price] as RangeValues?;
    _priceRange.value = priceRange ?? RangeValues(0, 2000);

    // Rating range
    final ratingRange =
        widget.currentFilters[FilterType.rating] as RangeValues?;
    _ratingRange.value = ratingRange ?? RangeValues(0.0, 5.0);
  }

  void _calculatePriceRange() {
    _minPrice = 0;
    _maxPrice = 2000;

    if (widget.plants.isNotEmpty) {
      _minPrice = double.infinity;
      _maxPrice = 0;

      for (var plant in widget.plants) {
        final price =
            (plant.prices?.offerPrice ?? plant.prices?.originalPrice ?? 0)
                .toDouble();
        if (price > 0) {
          _minPrice = _minPrice > price ? price : _minPrice;
          _maxPrice = _maxPrice < price ? price : _maxPrice;
        }
      }

      if (_minPrice == double.infinity) _minPrice = 0;
      if (_maxPrice == 0) _maxPrice = 2000;
    }

    // Ensure current price range is within bounds
    if (_priceRange.value.start < _minPrice ||
        _priceRange.value.start > _maxPrice ||
        _priceRange.value.end < _minPrice ||
        _priceRange.value.end > _maxPrice) {
      _priceRange.value = RangeValues(_minPrice, _maxPrice);
    }
  }

  void _clearAllFilters() {
    _selectedSort.value = 'Name A-Z';
    _selectedSize.value = 'All Sizes';
    _selectedCareLevel.value = 'All Levels';
    _selectedAttributes.value = <String>{};
    _inStockOnly.value = false;
    _priceRange.value = RangeValues(_minPrice, _maxPrice);
    _ratingRange.value = RangeValues(0.0, 5.0);
  }

  void _applyFilters() {
    final filters = <FilterType, dynamic>{};

    if (widget.enabledFilters.contains(FilterType.sort)) {
      filters[FilterType.sort] = _selectedSort.value;
    }
    if (widget.enabledFilters.contains(FilterType.price)) {
      filters[FilterType.price] = _priceRange.value;
    }
    if (widget.enabledFilters.contains(FilterType.rating)) {
      filters[FilterType.rating] = _ratingRange.value;
    }
    if (widget.enabledFilters.contains(FilterType.size)) {
      filters[FilterType.size] = _selectedSize.value;
    }
    if (widget.enabledFilters.contains(FilterType.careLevel)) {
      filters[FilterType.careLevel] = _selectedCareLevel.value;
    }
    if (widget.enabledFilters.contains(FilterType.attributes)) {
      filters[FilterType.attributes] = _selectedAttributes.value.toList();
    }
    if (widget.enabledFilters.contains(FilterType.stock)) {
      filters[FilterType.stock] = _inStockOnly.value;
    }

    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedPadding(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: AppSizes.paddingAllXs,
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.85.sh),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 5.h,
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter & Sort', style: textTheme.titleMedium),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _clearAllFilters,
                        child: Text(
                          'Reset',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: AppSizes.iconMd,
                          color: colorScheme.primary,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 32.w,
                          minHeight: 32.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sort Options
                    if (widget.enabledFilters.contains(FilterType.sort)) ...[
                      _buildSectionHeader('Sort by', Icons.sort),
                      SizedBox(height: 6.h),
                      ValueListenableBuilder<String>(
                        valueListenable: _selectedSort,
                        builder:
                            (context, selectedSort, _) => _buildCompactChips(
                              _sortOptions,
                              selectedSort,
                              (value) => _selectedSort.value = value,
                            ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Price Range
                    if (widget.enabledFilters.contains(FilterType.price)) ...[
                      _buildSectionHeader('Price Range', Icons.currency_rupee),
                      SizedBox(height: 6.h),
                      ValueListenableBuilder<RangeValues>(
                        valueListenable: _priceRange,
                        builder: (context, range, _) {
                          return _buildCompactPriceSlider(range);
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Rating Range
                    if (widget.enabledFilters.contains(FilterType.rating)) ...[
                      _buildSectionHeader('Rating', Icons.star),
                      SizedBox(height: 6.h),
                      _buildRatingSlider(),
                      SizedBox(height: 16.h),
                    ],

                    // Plant Size
                    if (widget.enabledFilters.contains(FilterType.size)) ...[
                      _buildSectionHeader('Plant Size', Icons.height),
                      SizedBox(height: 6.h),
                      ValueListenableBuilder<String>(
                        valueListenable: _selectedSize,
                        builder:
                            (context, selectedSize, _) => _buildCompactChips(
                              _sizeOptions,
                              selectedSize,
                              (value) => _selectedSize.value = value,
                            ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Care Level
                    if (widget.enabledFilters.contains(
                      FilterType.careLevel,
                    )) ...[
                      _buildSectionHeader(
                        'Care Level',
                        Icons.lightbulb_outline,
                      ),
                      SizedBox(height: 6.h),
                      ValueListenableBuilder<String>(
                        valueListenable: _selectedCareLevel,
                        builder:
                            (context, selectedCareLevel, _) =>
                                _buildCompactChips(
                                  _careLevelOptions,
                                  selectedCareLevel,
                                  (value) => _selectedCareLevel.value = value,
                                ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Plant Attributes (Multi-select)
                    if (widget.enabledFilters.contains(
                      FilterType.attributes,
                    )) ...[
                      _buildSectionHeader(
                        'Plant Attributes',
                        Icons.local_florist,
                      ),
                      SizedBox(height: 6.h),
                      ValueListenableBuilder<Set<String>>(
                        valueListenable: _selectedAttributes,
                        builder:
                            (context, selectedAttributes, _) =>
                                _buildAttributeChips(),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Stock Filter
                    if (widget.enabledFilters.contains(FilterType.stock)) ...[
                      _buildStockFilter(),
                      SizedBox(height: 16.h),
                    ],

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLg,
                vertical: AppSizes.paddingMd,
              ),
              decoration: BoxDecoration(color: colorScheme.surface),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      child: Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: AppSizes.iconSm, color: colorScheme.primary),
        SizedBox(width: 6.w),
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactChips(
    List<String> options,
    String selectedValue,
    Function(String) onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children:
          options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onTap(option),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  boxShadow: AppShadows.cardShadow(context),
                ),
                child: Text(
                  option,
                  style: textTheme.bodySmall?.copyWith(
                    color:
                        isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCompactPriceSlider(RangeValues range) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingSm),

      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: AppShadows.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${range.start.toInt()}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'to',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '₹${range.end.toInt()}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          RangeSlider(
            values: range,
            activeColor: colorScheme.primary,
            inactiveColor: colorScheme.primary.withValues(alpha: 0.2),
            min: _minPrice,
            max: _maxPrice,
            divisions:
                (_maxPrice - _minPrice).toInt() > 0
                    ? (_maxPrice - _minPrice).toInt().clamp(1, 100)
                    : 1,
            onChanged: (values) {
              _priceRange.value = values;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${_minPrice.toInt()}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '₹${_maxPrice.toInt()}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSlider() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(AppSizes.paddingSm),
      decoration: BoxDecoration(
        color: colorScheme.tertiary,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: AppShadows.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_ratingRange.value.start.toStringAsFixed(1)}★',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'to',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '${_ratingRange.value.end.toStringAsFixed(1)}★',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          RangeSlider(
            values: _ratingRange.value,
            activeColor: colorScheme.primary,
            inactiveColor: colorScheme.primary.withValues(alpha: 0.2),
            min: 0.0,
            max: 5.0,
            divisions: 10,
            onChanged: (values) => _ratingRange.value = values,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.0★',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '5.0★',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeChips() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 8.w,
      runSpacing: 2.h,
      children:
          _attributeOptions.map((attribute) {
            final isSelected = _selectedAttributes.value.contains(attribute);
            return FilterChip(
              label: Text(
                attribute,
                style: textTheme.bodySmall?.copyWith(
                  color:
                      isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _selectedAttributes.value = Set<String>.from(
                    _selectedAttributes.value,
                  )..add(attribute);
                } else {
                  _selectedAttributes.value = Set<String>.from(
                    _selectedAttributes.value,
                  )..remove(attribute);
                }
              },
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primary,
              checkmarkColor: colorScheme.onPrimary,

              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              shadowColor: colorScheme.shadow,
            );
          }).toList(),
    );
  }

  Widget _buildStockFilter() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.inventory, size: 16, color: colorScheme.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'In Stock Only',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Show only available plants',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _inStockOnly.value,
            onChanged: (value) => _inStockOnly.value = value,
            activeColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
