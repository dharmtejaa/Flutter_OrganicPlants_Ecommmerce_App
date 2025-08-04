import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:organicplants/shared/widgets/plant_card_grid.dart';
import 'package:organicplants/shared/widgets/plantcategory.dart';
class ProductSuggestionsSection extends StatelessWidget {
  final String plantId;

  const ProductSuggestionsSection({super.key, required this.plantId});

  List<AllPlantsModel> _getSuggestedPlants() {
    final AllPlantsModel? currentPlant = AllPlantsGlobalData.getById(plantId);
    List<AllPlantsModel> suggestions = [];
    // Priority 1: Same category plants (most relevant)
    final sameCategoryPlants = getPlantsByCategory(currentPlant!.category!);
    final categorySuggestions =
        sameCategoryPlants
            .where((plant) => plant.id != currentPlant.id)
            .take(3)
            .toList();
    suggestions.addAll(categorySuggestions);

    // Priority 2: Plants with similar tags
    if (currentPlant.tags != null && currentPlant.tags!.isNotEmpty) {
      for (String tag in currentPlant.tags!.take(3)) {
        final similarTagPlants = getPlantsByTag(tag);
        final tagSuggestions =
            similarTagPlants
                .where(
                  (plant) =>
                      plant.id != currentPlant.id &&
                      !suggestions.any((s) => s.id == plant.id),
                )
                .take(3)
                .toList();
        suggestions.addAll(tagSuggestions);
      }
    }

    // Priority 3: Plants with similar attributes
    if (currentPlant.attributes != null) {
      // Air purifying plants
      if (currentPlant.attributes!.isAirPurifying == true) {
        final airPurifyingSuggestions =
            airPurifyingPlants
                .where(
                  (plant) =>
                      plant.id != currentPlant.id &&
                      !suggestions.any((s) => s.id == plant.id),
                )
                .take(3)
                .toList();
        suggestions.addAll(airPurifyingSuggestions);
      }

      // Low maintenance plants
      if (currentPlant.attributes!.isLowMaintenance == true) {
        final lowMaintenanceSuggestions =
            lowMaintenancePlants
                .where(
                  (plant) =>
                      plant.id != currentPlant.id &&
                      !suggestions.any((s) => s.id == plant.id),
                )
                .take(3)
                .toList();
        suggestions.addAll(lowMaintenanceSuggestions);
      }

      // Pet friendly plants
      if (currentPlant.attributes!.isPetFriendly == true) {
        final petFriendlySuggestions =
            petFriendlyPlants
                .where(
                  (plant) =>
                      plant.id != currentPlant.id &&
                      !suggestions.any((s) => s.id == plant.id),
                )
                .take(3)
                .toList();
        suggestions.addAll(petFriendlySuggestions);
      }

      // Sun loving plants
      if (currentPlant.attributes!.isSunLoving == true) {
        final sunLovingSuggestions =
            sunLovingPlants
                .where(
                  (plant) =>
                      plant.id != currentPlant.id &&
                      !suggestions.any((s) => s.id == plant.id),
                )
                .take(3)
                .toList();
        suggestions.addAll(sunLovingSuggestions);
      }
    }

    // Priority 4: Similar price range plants
    if (currentPlant.prices != null) {
      final currentPrice = currentPlant.prices!.offerPrice ?? 0;
      final priceRange = currentPrice * 0.3; // 30% price range

      final similarPricePlants =
          allPlantsGlobal
              .where(
                (plant) =>
                    plant.id != currentPlant.id &&
                    !suggestions.any((s) => s.id == plant.id) &&
                    plant.prices != null &&
                    (plant.prices!.offerPrice ?? 0) >=
                        (currentPrice - priceRange) &&
                    (plant.prices!.offerPrice ?? 0) <=
                        (currentPrice + priceRange),
              )
              .take(3)
              .toList();
      suggestions.addAll(similarPricePlants);
    }

    // Priority 5: Popular plants (high rating)
    final popularPlants =
        allPlantsGlobal
            .where(
              (plant) =>
                  plant.id != currentPlant.id &&
                  !suggestions.any((s) => s.id == plant.id) &&
                  (plant.rating ?? 0) >= 4.0,
            )
            .take(3)
            .toList();
    suggestions.addAll(popularPlants);

    // Remove duplicates and limit to 6 suggestions
    final uniqueSuggestions = suggestions.toSet().toList();
    return uniqueSuggestions.take(15).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final suggestedPlants = _getSuggestedPlants();

    if (suggestedPlants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: AppSizes.paddingAllSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Suggested Plants",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PlantCategory(
                            plant: suggestedPlants,
                            category: 'Similar Plants',
                          ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
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
          ),
          //SizedBox(height: 8.h),
          Text(
            'Discover more plants that match your style',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 240.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: suggestedPlants.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final plant = suggestedPlants[index];
                return SizedBox(
                  width: 150.w,
                  child: ProductCardGrid(plantId: plant.id!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
