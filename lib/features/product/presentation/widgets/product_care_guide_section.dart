import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/appcolors.dart';
import 'package:organicplants/features/profile/presentation/widgets/profile_custom_icon.dart';
import 'package:organicplants/models/all_plants_model.dart';

class ProductCareGuideSection extends StatelessWidget {
  final String plantId;

  const ProductCareGuideSection({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppSizes.paddingAllSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 12.h),
          Text('Plant Highlights', style: textTheme.titleLarge),
          SizedBox(height: 12.h),
          QuickGuideCard(plantId: plant!.id!),
          SizedBox(height: 14.h),
          // Care Guid
          Text('Plant Care Guide', style: textTheme.titleLarge),
          SizedBox(height: 12.h),
          CareGuideSection(plantId: plantId),
          SizedBox(height: 12.h),

          // FAQs
          Text('FAQs', style: textTheme.titleLarge),
          SizedBox(height: 8.h),
          FAQSection(plantId: plant.id!),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

class QuickGuideCard extends StatelessWidget {
  final String plantId;

  const QuickGuideCard({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);
    final guide = plant!.plantQuickGuide!;
    final colorScheme = Theme.of(context).colorScheme;

    final items = [
      _GuideCard(
        icon: Icons.height,
        label: 'Height',
        value: guide.height,
        color: colorScheme.primary,
        bgColor: colorScheme.primaryContainer,
      ),
      _GuideCard(
        icon: Icons.width_full,
        label: 'Width',
        value: guide.width,
        color: colorScheme.secondary,
        bgColor: colorScheme.secondaryContainer,
      ),
      _GuideCard(
        icon: Icons.wb_sunny_outlined,
        label: 'Sunlight',
        value: guide.sunlight,
        color: Colors.amber,
        bgColor: Colors.amber.shade50,
      ),
      _GuideCard(
        icon: Icons.trending_up,
        label: 'Growth Rate',
        value: guide.growthRate,
        color: Colors.green,
        bgColor: Colors.green.shade50,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2.1,
      children: items.map((item) => item).toList(),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic value;
  final Color color;
  final Color bgColor;

  const _GuideCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 0,
      shadowColor: colorScheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: AppSizes.paddingAllSm,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileCustomIcon(
              icon: icon,
              iconColor: color,
              containerSize: 36.w,
              iconSize: AppSizes.iconMd,
            ),
            SizedBox(width: 7.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: textTheme.titleSmall),
                  SizedBox(height: 1.h),
                  Text(
                    _listToString(value),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _listToString(dynamic value) {
    if (value is List) return value.join(", ");
    return value.toString();
  }
}

class CareGuideSection extends StatelessWidget {
  final String plantId;

  const CareGuideSection({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);
    final care = plant!.careGuide;
    if (care == null) return const SizedBox();

    final items = [
      _CareItem(
        icon: Icons.water_drop_outlined,
        label: 'Watering',
        value: care.watering?.frequency ?? '',
        description: care.watering?.description ?? '',
        color: AppColors.info,
        // ignore: deprecated_member_use
        bgColor: AppColors.info.withOpacity(0.12),
      ),
      _CareItem(
        icon: Icons.thermostat_outlined,
        label: 'Temperature',
        value: care.temperature?.range ?? '',
        description: care.temperature?.description ?? '',
        color: AppColors.warning,
        // ignore: deprecated_member_use
        bgColor: AppColors.warning.withOpacity(0.12),
      ),
      _CareItem(
        icon: Icons.water_damage_outlined,
        label: 'Humidity',
        value: care.humidity?.level ?? '',
        description: care.humidity?.description ?? '',
        color: AppColors.secondaryOrange,
        // ignore: deprecated_member_use
        bgColor: AppColors.secondaryOrange.withOpacity(0.12),
      ),
      _CareItem(
        icon: Icons.eco_outlined,
        label: 'Fertilizer',
        value: care.fertilizer?.type ?? '',
        description: care.fertilizer?.description ?? '',
        color: AppColors.primaryGreen,
        // ignore: deprecated_member_use
        bgColor: AppColors.primaryGreen.withOpacity(0.12),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...items.map((item) => _CareCard(item: item))],
    );
  }
}

class _CareItem {
  final IconData icon;
  final String label;
  final String value;
  final String description;
  final Color color;
  final Color bgColor;
  _CareItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.description,
    required this.color,
    required this.bgColor,
  });
}

class _CareCard extends StatelessWidget {
  final _CareItem item;
  _CareCard({required this.item});
  final ValueNotifier<bool> expandedNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      shadowColor: colorScheme.shadow,
      color: colorScheme.surfaceContainer,
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: GestureDetector(
        onTap: () => expandedNotifier.value = !expandedNotifier.value,
        child: Padding(
          padding: AppSizes.paddingAllSm,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCustomIcon(
                icon: item.icon,
                iconColor: item.color,
                containerSize: 35.w,
                iconSize: AppSizes.iconMd,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.label, style: textTheme.titleMedium),
                            SizedBox(width: 8.w),
                            SizedBox(
                              width: 250.w,
                              child: Text(
                                item.value,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        ValueListenableBuilder<bool>(
                          valueListenable: expandedNotifier,
                          builder:
                              (context, expanded, _) => Icon(
                                expanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: colorScheme.onSurface,
                                size: AppSizes.iconSm,
                              ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: expandedNotifier,
                      builder:
                          (context, expanded, _) => AnimatedCrossFade(
                            firstChild: SizedBox.shrink(),
                            secondChild: Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                item.description,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            crossFadeState:
                                expanded
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: 250),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  final String plantId;

  const FAQSection({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);
    final colorScheme = Theme.of(context).colorScheme;
    final faqs = plant!.faqs;
    if (faqs == null) return const SizedBox();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return _FAQCard(
          question: faq.question ?? '',
          answer: faq.answer ?? '',
          color: colorScheme.primary,

          // ignore: deprecated_member_use
        );
      },
    );
  }
}

class _FAQCard extends StatelessWidget {
  final String question;
  final String answer;
  final Color color;

  _FAQCard({required this.question, required this.answer, required this.color});
  final ValueNotifier<bool> expandedNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: AppSizes.paddingAllSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Q. $question', style: textTheme.titleMedium),
          SizedBox(height: 3.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A.'),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  answer,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
