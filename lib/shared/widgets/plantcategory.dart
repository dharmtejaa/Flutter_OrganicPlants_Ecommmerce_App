import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/plant_filter_service.dart';
import 'package:organicplants/features/cart/presentation/screens/cart_screen.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:organicplants/shared/buttons/cart_icon_with_batdge.dart';
import 'package:organicplants/shared/buttons/searchbutton.dart';
import 'package:organicplants/shared/buttons/wishlist_icon_with_badge.dart';
import 'package:organicplants/shared/widgets/active_filters_widget.dart';
import 'package:organicplants/shared/widgets/filter_bottom_sheet.dart';
import 'package:organicplants/shared/widgets/no_result_found.dart';
import 'package:organicplants/shared/widgets/plant_card_grid.dart';

class PlantCategory extends StatefulWidget {
  final List<AllPlantsModel> plant;
  final String category;
  const PlantCategory({super.key, required this.plant, required this.category});

  @override
  State<PlantCategory> createState() => _PlantCategoryState();
}

class _PlantCategoryState extends State<PlantCategory> {
  late final ValueNotifier<Map<FilterType, dynamic>> _filtersNotifier;
  final List<FilterType> _enabledFilters = [
    FilterType.sort,
    FilterType.price,
    FilterType.size,
    FilterType.careLevel,
  ];
  late RangeValues _originalPriceRange;

  // Cache for expensive computations
  final Map<String, List<AllPlantsModel>> _filteredPlantsCache = {};
  Map<FilterType, dynamic>? _lastFilters;

  // Memoized main categories list
  static const List<String> _mainCategories = [
    'Indoor Plants',
    'Outdoor Plants',
    'Herbs Plants',
    'Succulents Plants',
    'Flowering Plants',
    'Bonsai Plants',
    'Medicinal Plants',
  ];

  @override
  void initState() {
    super.initState();
    _filtersNotifier = ValueNotifier<Map<FilterType, dynamic>>({});
    _initializeFilters();
  }

  @override
  void dispose() {
    _filtersNotifier.dispose();
    _filteredPlantsCache.clear();
    super.dispose();
  }

  void _initializeFilters() {
    // Set default filters
    final filters = <FilterType, dynamic>{};
    filters[FilterType.sort] = 'Name A-Z';
    _originalPriceRange = PlantFilterService.calculatePriceRange(widget.plant);
    filters[FilterType.price] = _originalPriceRange;
    filters[FilterType.size] = 'All Sizes';
    filters[FilterType.careLevel] = 'All Levels';
    _filtersNotifier.value = filters;

    // Clear cache when filters are reset
    _filteredPlantsCache.clear();
    _lastFilters = null;
  }

  void _showFilterBottomSheet() {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      barrierColor: colorScheme.shadow.withValues(alpha: 0.15),
      builder: (context) {
        return FilterBottomSheet(
          plants: widget.plant,
          currentFilters: _filtersNotifier.value,
          enabledFilters: _enabledFilters,
          onApplyFilters: (filters) {
            _filtersNotifier.value = Map<FilterType, dynamic>.from(filters);
            // Clear cache when filters change
            _filteredPlantsCache.clear();
            _lastFilters = null;
          },
          // Example usage:
          // showApplyToAllTabs: true,
          // onApplyFiltersForAllTabs: (filters) {
          //   // Implement logic to apply filters to all tabs if needed
          // },
        );
      },
    );
  }

  // Memoized filtered plants calculation
  List<AllPlantsModel> getFilteredPlants() {
    final cacheKey = _filtersNotifier.value.hashCode.toString();

    // Check if we can use cached result
    if (_filteredPlantsCache.containsKey(cacheKey) &&
        _lastFilters == _filtersNotifier.value) {
      return _filteredPlantsCache[cacheKey] ?? [];
    }

    final filteredPlants = PlantFilterService.getFilteredPlants(
      plants: widget.plant,
      filters: _filtersNotifier.value,
    );

    // Cache the result
    _filteredPlantsCache[cacheKey] = filteredPlants;
    _lastFilters = Map.from(_filtersNotifier.value);

    // Limit cache size
    if (_filteredPlantsCache.length > 5) {
      _filteredPlantsCache.clear();
    }

    return filteredPlants;
  }

  // Memoized active filters check
  bool _hasActiveFilters() {
    return _filtersNotifier.value.entries.any((entry) {
      final key = entry.key;
      final value = entry.value;
      if (key == FilterType.sort) {
        return value != 'Name A-Z';
      } else if (key == FilterType.size) {
        return value != 'All Sizes';
      } else if (key == FilterType.careLevel) {
        return value != 'All Levels';
      } else if (key == FilterType.attributes) {
        return (value as List<String>).isNotEmpty;
      }
      return value != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bool isMainCategory = _mainCategories.contains(widget.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category, style: textTheme.headlineMedium),

        actions: [
          SearchButton(),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: Icon(
              Icons.filter_list_rounded,
              size: AppSizes.iconMd,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 10.w),
          WishlistIconWithBadge(),
          SizedBox(width: 10.w),
          CartIconWithBadge(
            iconColor: colorScheme.onSurface,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSizes.paddingSymmetricSm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active filters widget
              ValueListenableBuilder<Map<FilterType, dynamic>>(
                valueListenable: _filtersNotifier,
                builder: (context, filters, child) {
                  final filteredPlants = getFilteredPlants();
                  final hasActiveFilters = _hasActiveFilters();

                  return Column(
                    children: [
                      // Active filters widget
                      if (hasActiveFilters && filteredPlants.isNotEmpty)
                        ActiveFiltersWidget(
                          currentFilters: _filtersNotifier.value,
                          plantCount: filteredPlants.length,
                          onClearAll: () {
                            _initializeFilters();
                          },
                          showPlantCount: true,
                          originalPriceRange: _originalPriceRange,
                        ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ValueListenableBuilder<Map<FilterType, dynamic>>(
                  valueListenable: _filtersNotifier,
                  builder: (context, filters, child) {
                    final filteredPlants = getFilteredPlants();

                    return filteredPlants.isEmpty
                        ? _buildEmptyState(colorScheme, textTheme)
                        : _buildPlantGrid(filteredPlants, isMainCategory);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: NoResultsFound(
        title: "No plants found",
        message: "Try adjusting your fiters or Search.",
        imagePath:
            "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080574/No_Plant_Found_dmdjsy.png",
      ),
    );
  }

  Widget _buildPlantGrid(
    List<AllPlantsModel> filteredPlants,
    bool isMainCategory,
  ) {
    return GridView.builder(
      itemCount: filteredPlants.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
        childAspectRatio: 0.73,
      ),

      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ProductCardGrid(
          plantId: filteredPlants[index].id ?? '',
          scifiname: isMainCategory,
        );
      },
    );
  }
}
