import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/models/all_plants_model.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String plantId;

  const ProductDescriptionSection({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppSizes.paddingAllSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: textTheme.titleLarge),
          Padding(
            padding: AppSizes.paddingAllSm,
            child: Text(
              plant!.description?.intro ?? '',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              maxLines: 5,
            ),
          ),
          SizedBox(height: 12.h),
          Text('Product Details', style: textTheme.titleLarge),
          PlantDetails(plantId: plant.id!),
        ],
      ),
    );
  }
}

class PlantDetails extends StatelessWidget {
  final String plantId;

  const PlantDetails({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);
    final Map<String, String> detailsMap = {
      "Plant Name": plant!.commonName ?? '',
      "Scientific Name": plant.scientificName ?? '',
      "Category": plant.category ?? '',
      "Toxicity": plant.toxicity ?? "-",
      "Sunlight": _listToString(plant.plantQuickGuide?.sunlight),
      "Placement": plant.placement ?? '',
      "Season": plant.season ?? '',
      "Soil Type": plant.soilType ?? '',
      "Recommeded Pot Size": plant.recommendedPotSize ?? '',
      "Lifecycle Stage": plant.lifecycleStage ?? '',
      "Growth Rate": plant.plantQuickGuide?.growthRate ?? '',
      "Height": plant.plantQuickGuide?.height ?? '',
      "Width": plant.plantQuickGuide?.width ?? '',
      "Benefits": _listToString(plant.benefits),
      "How to plant": plant.howToPlant ?? '',
    };
    return Padding(
      padding: AppSizes.paddingAllSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...detailsMap.entries.map(
            (entry) => _buildRow(entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Builder(
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(label, style: textTheme.bodyMedium),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _listToString(dynamic value) {
    if (value is List) return value.join(', ');
    return value?.toString() ?? "-";
  }
}
