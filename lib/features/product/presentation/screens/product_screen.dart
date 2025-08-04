import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/features/cart/presentation/screens/cart_screen.dart';
import 'package:organicplants/features/product/presentation/widgets/product_bottom_bar.dart';
import 'package:organicplants/features/product/presentation/widgets/product_care_guide_section.dart';
import 'package:organicplants/features/product/presentation/widgets/product_description_section.dart';
import 'package:organicplants/features/product/presentation/widgets/product_features_section.dart';
import 'package:organicplants/features/product/presentation/widgets/product_header_info.dart';
import 'package:organicplants/features/product/presentation/widgets/product_image_gallery.dart';
import 'package:organicplants/features/product/presentation/widgets/product_suggestions_section.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:organicplants/shared/buttons/cart_icon_with_batdge.dart';
import 'package:organicplants/shared/buttons/searchbutton.dart';

class ProductScreen extends StatelessWidget {
  final String plantId;

  ProductScreen({super.key, required this.plantId});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          plant?.commonName ?? "empty",
          style: textTheme.headlineMedium,
        ),
        actions: [
          SearchButton(),
          SizedBox(width: 10.w),
          CartIconWithBadge(
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 90.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery Section
                ProductImageGallery(plantId: plant!.id!),
                SizedBox(height: 12.h),
                // Product Header Info Section
                ProductHeaderInfo(plantId: plant.id!),
                SizedBox(height: 16.h),
                // Product Features Section
                ProductFeaturesSection(searchController: searchController),
                SizedBox(height: 12.h),
                Divider(thickness: 6.h),
                SizedBox(height: 12.h),
                // Product Description Section
                ProductDescriptionSection(plantId: plantId),
                SizedBox(height: 12.h),
                Divider(thickness: 6.h),
                SizedBox(height: 12.h),
                // Product Care Guide Section
                ProductCareGuideSection(plantId: plant.id!),
                // Reviews section
                SizedBox(height: 12.h),
                Divider(thickness: 6.h),
                SizedBox(height: 12.h),
                _DefaultReviewsSection(),
                // Product Suggestions Section
                SizedBox(height: 12.h),
                Divider(thickness: 6.h),
                SizedBox(height: 12.h),
                ProductSuggestionsSection(plantId: plant.id!),
              ],
            ),
          ),
          // Sticky Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ProductBottomBar(plantId: plant.id!),
          ),
        ],
      ),
    );
  }
}

class _DefaultReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final reviews = [
      {
        'name': 'Amit Sharma',
        'rating': 5,
        'review':
            'Beautiful plant, healthy and well packed. Delivery was quick! Highly recommend.',
        'date': '2 days ago',
      },
      {
        'name': 'Priya Singh',
        'rating': 4,
        'review':
            'Plant is good, but pot was a bit small. Otherwise, very happy!',
        'date': '1 week ago',
      },
      {
        'name': 'Rahul Verma',
        'rating': 5,
        'review': 'Excellent quality and lush green leaves. Will buy again.',
        'date': '3 weeks ago',
      },
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer Reviews', style: textTheme.titleLarge),
          SizedBox(height: 10.h),
          ...reviews.map(
            (review) => _ReviewCard(
              review: review,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map review;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  const _ReviewCard({
    required this.review,
    required this.colorScheme,
    required this.textTheme,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  // ignore: deprecated_member_use
                  backgroundColor: colorScheme.primary.withOpacity(0.15),
                  child: Text(
                    review['name'][0],
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review['name'], style: textTheme.titleMedium),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < review['rating']
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          review['date'],
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(review['review'], style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
