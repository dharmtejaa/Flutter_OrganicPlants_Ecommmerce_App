// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/profile/presentation/screens/customer_support_screen.dart';
import 'package:organicplants/features/profile/presentation/widgets/profile_custom_icon.dart';
import 'package:organicplants/shared/buttons/custombutton.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';

class PlantCareGuideScreen extends StatefulWidget {
  const PlantCareGuideScreen({super.key});

  @override
  State<PlantCareGuideScreen> createState() => _PlantCareGuideScreenState();
}

class _PlantCareGuideScreenState extends State<PlantCareGuideScreen> {
  final List<Map<String, dynamic>> _careGuides = [
    {
      'title': 'Watering Basics',
      'icon': Icons.water_drop_outlined,
      'color': Colors.blue,
      'description': 'Learn the fundamentals of proper plant watering',
      'content': [
        'Water when the top 1-2 inches of soil feels dry',
        'Use room temperature water',
        'Water thoroughly until it drains from the bottom',
        'Avoid overwatering - it\'s the most common cause of plant death',
      ],
    },
    {
      'title': 'Light Requirements',
      'icon': Icons.wb_sunny_outlined,
      'color': Colors.orange,
      'description': 'Understanding your plant\'s light needs',
      'content': [
        'Direct sunlight: 6+ hours of direct sun',
        'Bright indirect light: Near a sunny window',
        'Medium light: 3-4 feet from a window',
        'Low light: Can survive in darker corners',
      ],
    },
    {
      'title': 'Soil & Potting',
      'icon': Icons.eco_outlined,
      'color': Colors.brown,
      'description': 'Choosing the right soil and containers',
      'content': [
        'Use well-draining potting mix',
        'Choose pots with drainage holes',
        'Repot when roots outgrow the container',
        'Use appropriate pot size for your plant',
      ],
    },
    {
      'title': 'Temperature & Humidity',
      'icon': Icons.thermostat_outlined,
      'color': Colors.green,
      'description': 'Creating the ideal environment',
      'content': [
        'Most houseplants prefer 65-75°F (18-24°C)',
        'Avoid cold drafts and hot air vents',
        'Increase humidity with humidifiers or pebble trays',
        'Group plants together to create microclimates',
      ],
    },
    {
      'title': 'Fertilizing',
      'icon': Icons.grass_outlined,
      'color': Colors.purple,
      'description': 'Feeding your plants properly',
      'content': [
        'Fertilize during growing season (spring/summer)',
        'Use balanced, water-soluble fertilizer',
        'Dilute to half strength for most plants',
        'Reduce or stop fertilizing in winter',
      ],
    },
    {
      'title': 'Pruning & Maintenance',
      'icon': Icons.content_cut_outlined,
      'color': Colors.red,
      'description': 'Keeping your plants healthy and beautiful',
      'content': [
        'Remove dead or yellowing leaves',
        'Prune to encourage bushier growth',
        'Clean leaves regularly to remove dust',
        'Check for pests and diseases weekly',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Care Guide', style: textTheme.headlineMedium),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
            size: AppSizes.iconMd,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.onSurface),
            onPressed: _searchCareGuides,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSizes.paddingAllSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: AppSizes.paddingAllSm,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 14, 172, 114),
                    Color.fromARGB(255, 21, 208, 140),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.eco_rounded,
                        size: AppSizes.iconLg,
                        color: colorScheme.onPrimary,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          "Welcome to Plant Care",
                          style: textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Learn essential tips and tricks to keep your plants healthy and thriving. Whether you're a beginner or experienced gardener, we have everything you need to know.",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Care Guides Grid
            Text("Care Topics", style: textTheme.titleLarge),
            SizedBox(height: 16.h),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                //crossAxisSpacing: 12.w,
                //mainAxisSpacing: 12.h,
                childAspectRatio: 0.9,
              ),
              itemCount: _careGuides.length,
              itemBuilder: (context, index) {
                return _buildCareGuideCard(_careGuides[index]);
              },
            ),

            SizedBox(height: 24.h),

            // Quick Tips Section
            _buildQuickTipsSection(),

            SizedBox(height: 24.h),

            // Emergency Care Section
            _buildEmergencyCareSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCareGuideCard(Map<String, dynamic> guide) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: InkWell(
        onTap: () => _showCareGuideDetails(guide),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Padding(
          padding: AppSizes.paddingAllSm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCustomIcon(icon: guide['icon'], iconColor: guide['color']),
              SizedBox(height: 12.h),
              Text(guide['title'], style: textTheme.titleLarge),
              SizedBox(height: 4.h),
              Text(
                guide['description'],
                style: textTheme.labelMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    "Learn More",
                    style: textTheme.labelMedium?.copyWith(
                      color: guide['color'],
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: AppSizes.iconsUxs,
                    color: guide['color'],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTipsSection() {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: AppSizes.paddingAllSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber,
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: 8.w),
                Text("Quick Tips", style: textTheme.titleLarge),
              ],
            ),
            SizedBox(height: 16.h),
            _buildQuickTip("Rotate your plants weekly for even growth"),
            _buildQuickTip("Use filtered or rainwater for sensitive plants"),
            _buildQuickTip(
              "Keep a care journal to track your plant's progress",
            ),
            _buildQuickTip("Group plants with similar care needs together"),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTip(String tip) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: AppSizes.paddingAllSm,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: AppSizes.iconXs,
            color: colorScheme.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(child: Text(tip, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildEmergencyCareSection() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: AppSizes.paddingAllSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emergency_outlined,
                  color: Colors.red,
                  size: AppSizes.iconSm,
                ),
                SizedBox(width: 8.w),
                Text("Emergency Care", style: textTheme.titleLarge),
              ],
            ),
            SizedBox(height: 16.h),
            _buildEmergencyTip(
              "Overwatered Plant",
              "Remove from pot, let roots dry, repot in fresh soil",
              Icons.water_drop_outlined,
            ),
            _buildEmergencyTip(
              "Underwatered Plant",
              "Soak in water for 30 minutes, then resume normal watering",
              Icons.dry_outlined,
            ),
            _buildEmergencyTip(
              "Pest Infestation",
              "Isolate plant, treat with neem oil or insecticidal soap",
              Icons.bug_report_outlined,
            ),
            SizedBox(height: 16.h),
            CustomButton(
              backgroundColor: colorScheme.primary,
              text: "Contact Plant Expert",
              textColor: colorScheme.onPrimary,
              ontap: _contactSupport,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyTip(String title, String solution, IconData icon) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: Colors.red),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.bodyMedium),
                SizedBox(height: 2.h),
                Text(solution, style: textTheme.labelMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCareGuideDetails(Map<String, dynamic> guide) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: 0.8.sh,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusLg),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: EdgeInsets.only(top: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                // Header
                Padding(
                  padding: AppSizes.paddingAllSm,
                  child: Row(
                    children: [
                      ProfileCustomIcon(
                        icon: guide['icon'],
                        iconColor: guide['color'],
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guide['title'],
                              style: textTheme.headlineMedium,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              guide['description'],
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: ListView.builder(
                    padding: AppSizes.paddingAllSm,
                    itemCount: guide['content'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: AppSizes.paddingAllSm,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 6.h),
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: guide['color'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                guide['content'][index],
                                style: textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _searchCareGuides() {
    CustomSnackBar.showInfo(context, "Search feature coming soon!");
  }

  void _contactSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerSupportScreen()),
    );
  }
}
