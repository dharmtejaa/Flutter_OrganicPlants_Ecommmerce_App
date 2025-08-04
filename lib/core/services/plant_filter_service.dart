import 'package:flutter/material.dart';
import 'package:organicplants/models/all_plants_model.dart';

enum FilterType { sort, price, rating, size, careLevel, attributes, stock }

class PlantFilterService {
  // Cache for price range calculations
  static final Map<String, RangeValues> _priceRangeCache = {};

  static List<AllPlantsModel> getFilteredPlants({
    required List<AllPlantsModel> plants,
    Map<FilterType, dynamic>? filters,
  }) {
    if (filters == null || filters.isEmpty) {
      return List.from(plants);
    }

    // Apply filters in order of most restrictive first for better performance
    List<AllPlantsModel> filtered = List.from(plants);

    // Stock Filter (most restrictive)
    if (filters.containsKey(FilterType.stock)) {
      final inStockOnly = filters[FilterType.stock] as bool;
      if (inStockOnly) {
        filtered = filtered.where((plant) => plant.inStock == true).toList();
      }
    }

    // Price Range Filter (very restrictive)
    if (filters.containsKey(FilterType.price)) {
      final priceRange = filters[FilterType.price] as RangeValues;
      filtered =
          filtered.where((plant) {
            final price =
                plant.prices?.offerPrice ?? plant.prices?.originalPrice ?? 0;
            return price >= priceRange.start && price <= priceRange.end;
          }).toList();
    }

    // Rating Range Filter (restrictive)
    if (filters.containsKey(FilterType.rating)) {
      final ratingRange = filters[FilterType.rating] as RangeValues;
      filtered =
          filtered.where((plant) {
            final rating = plant.rating ?? 0;
            return rating >= ratingRange.start && rating <= ratingRange.end;
          }).toList();
    }

    // Plant Size Filter
    if (filters.containsKey(FilterType.size)) {
      final selectedSize = filters[FilterType.size] as String;
      if (selectedSize != 'All Sizes') {
        filtered =
            filtered.where((plant) {
              final height = plant.plantQuickGuide?.height;
              if (height == null) return false;

              // Extract numeric values from height string (e.g., "1-2 feet" -> [1, 2])
              final heightMatch = RegExp(r'(\d+)').allMatches(height);
              if (heightMatch.isEmpty) return false;

              final heightValues =
                  heightMatch.map((m) => int.parse(m.group(1)!)).toList();
              final maxHeight = heightValues.reduce((a, b) => a > b ? a : b);

              switch (selectedSize) {
                case 'Small Plants':
                  return maxHeight <= 2; // 1-2 feet
                case 'Medium Plants':
                  return maxHeight >= 2 && maxHeight <= 4; // 2-4 feet
                case 'Large Plants':
                  return maxHeight >= 5; // 5+ feet
                default:
                  return true;
              }
            }).toList();
      }
    }

    // Care Level Filter
    if (filters.containsKey(FilterType.careLevel)) {
      final selectedCareLevel = filters[FilterType.careLevel] as String;
      if (selectedCareLevel != 'All Levels') {
        filtered =
            filtered.where((plant) {
              final attributes = plant.attributes;
              if (attributes == null) return false;

              switch (selectedCareLevel) {
                case 'Beginner Friendly':
                  return attributes.isBeginnerFriendly == true;
                case 'Low Maintenance':
                  return attributes.isLowMaintenance == true;
                case 'High Maintenance':
                  return (attributes.isBeginnerFriendly != true) &&
                      (attributes.isLowMaintenance != true);
                default:
                  return true;
              }
            }).toList();
      }
    }

    // Plant Attributes Filter (Multi-select)
    if (filters.containsKey(FilterType.attributes)) {
      final selectedAttributes = filters[FilterType.attributes] as List<String>;
      if (selectedAttributes.isNotEmpty) {
        filtered =
            filtered.where((plant) {
              final attributes = plant.attributes;
              if (attributes == null) return false;

              // Check if plant has any of the selected attributes
              for (final attribute in selectedAttributes) {
                bool hasAttribute = false;

                switch (attribute) {
                  case 'Pet Friendly':
                    hasAttribute = attributes.isPetFriendly == true;
                    break;
                  case 'Air Purifying':
                    hasAttribute = attributes.isAirPurifying == true;
                    break;
                  case 'Low Maintenance':
                    hasAttribute = attributes.isLowMaintenance == true;
                    break;
                  case 'Sun Loving':
                    hasAttribute = attributes.isSunLoving == true;
                    break;
                  case 'Shade Loving':
                    hasAttribute = attributes.isShadowLoving == true;
                    break;
                  case 'Flowering':
                    hasAttribute = attributes.isFlowering == true;
                    break;
                  case 'Non-Flowering':
                    hasAttribute = attributes.isFlowering == false;
                    break;
                  case 'Beginner Friendly':
                    hasAttribute = attributes.isBeginnerFriendly == true;
                    break;
                  case 'High Maintenance':
                    hasAttribute =
                        (attributes.isBeginnerFriendly != true) &&
                        (attributes.isLowMaintenance != true);
                    break;
                }

                if (hasAttribute) return true;
              }

              return false;
            }).toList();
      }
    }

    // Sort (apply last as it doesn't reduce the list)
    if (filters.containsKey(FilterType.sort)) {
      final selectedSortOption = filters[FilterType.sort] as String;
      _applySorting(filtered, selectedSortOption);
    }

    return filtered;
  }

  // Separate sorting method for better performance
  static void _applySorting(List<AllPlantsModel> plants, String sortOption) {
    switch (sortOption) {
      case 'Name A-Z':
        plants.sort(
          (a, b) => (a.commonName ?? '').compareTo(b.commonName ?? ''),
        );
        break;
      case 'Name Z-A':
        plants.sort(
          (a, b) => (b.commonName ?? '').compareTo(a.commonName ?? ''),
        );
        break;
      case 'Price Low to High':
        plants.sort((a, b) {
          final priceA = a.prices?.offerPrice ?? a.prices?.originalPrice ?? 0;
          final priceB = b.prices?.offerPrice ?? b.prices?.originalPrice ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price High to Low':
        plants.sort((a, b) {
          final priceA = a.prices?.offerPrice ?? a.prices?.originalPrice ?? 0;
          final priceB = b.prices?.offerPrice ?? b.prices?.originalPrice ?? 0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'Rating High to Low':
        plants.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'Most Popular':
        plants.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'Newest First':
        plants.sort((a, b) => (b.id ?? '').compareTo(a.id ?? ''));
        break;
    }
  }

  static RangeValues calculatePriceRange(List<AllPlantsModel> plants) {
    // Create a cache key based on plant list length and first few IDs
    final cacheKey =
        plants.length.toString() +
        (plants.isNotEmpty ? '_${plants.first.id}' : '') +
        (plants.length > 1 ? '_${plants[1].id}' : '');

    // Check cache first
    if (_priceRangeCache.containsKey(cacheKey)) {
      return _priceRangeCache[cacheKey]!;
    }

    if (plants.isEmpty) {
      return const RangeValues(0, 2000);
    }

    double minPrice = double.infinity;
    double maxPrice = 0;

    // Single pass through the list
    for (var plant in plants) {
      final price =
          (plant.prices?.offerPrice ?? plant.prices?.originalPrice ?? 0)
              .toDouble();
      if (price > 0) {
        if (price < minPrice) minPrice = price;
        if (price > maxPrice) maxPrice = price;
      }
    }

    RangeValues result;
    if (minPrice != double.infinity && maxPrice > 0) {
      result = RangeValues(minPrice, maxPrice);
    } else {
      result = const RangeValues(0, 2000);
    }

    // Cache the result
    _priceRangeCache[cacheKey] = result;

    // Limit cache size to prevent memory leaks
    if (_priceRangeCache.length > 10) {
      _priceRangeCache.clear();
    }

    return result;
  }

  // Clear cache when needed (e.g., when data changes)
  static void clearCache() {
    _priceRangeCache.clear();
  }

  // Helper method for backward compatibility
  static List<AllPlantsModel> getFilteredPlantsLegacy({
    required List<AllPlantsModel> plants,
    required String selectedSortOption,
    required RangeValues priceRange,
    required String selectedSize,
    required String selectedCareLevel,
    double minRating = 0,
  }) {
    final filters = <FilterType, dynamic>{
      FilterType.sort: selectedSortOption,
      FilterType.price: priceRange,
      FilterType.size: selectedSize,
      FilterType.careLevel: selectedCareLevel,
      FilterType.rating: RangeValues(minRating, 5.0),
    };

    return getFilteredPlants(plants: plants, filters: filters);
  }
}
