import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/shared/widgets/custom_textfield.dart';
import 'package:organicplants/shared/buttons/custombutton.dart';

class ProductFeaturesSection extends StatefulWidget {
  final TextEditingController searchController;

  const ProductFeaturesSection({super.key, required this.searchController});

  @override
  State<ProductFeaturesSection> createState() => _ProductFeaturesSectionState();
}

class _ProductFeaturesSectionState extends State<ProductFeaturesSection> {
  final FocusNode _pincodeFocusNode = FocusNode();

  @override
  void dispose() {
    _pincodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppSizes.paddingAllSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Check', style: textTheme.titleLarge),
          SizedBox(height: 12.h),
          // Delivery Check
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                width: 180.w,
                contentPadding: AppSizes.paddingAllSm,
                fillColor: colorScheme.tertiary,
                controller: widget.searchController,
                keyboardType: TextInputType.number,
                hintText: 'Enter Pincode',
                prefixIcon: Icons.location_on,
              ),
              SizedBox(width: 10.w),
              CustomButton(
                backgroundColor: colorScheme.primary,
                text: "Check",
                textColor: colorScheme.onPrimary,
                height: 43.h,
                width: 70.w,
                ontap: () async {
                  // Clear focus when checking pincode
                  _pincodeFocusNode.unfocus();
                },
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Key Features
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ProductFeatureCard(
                  title: 'Free Delivery',
                  subtitle: 'On Orders Above ₹499',
                  imagePath:
                      'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080733/free-shipping_w4sua1.png',
                ),
                SizedBox(width: 8.w),
                ProductFeatureCard(
                  title: '7-Day Replacement',
                  subtitle: 'Hassle-free return',
                  imagePath:
                      'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080732/exchange_hjc0rm.png',
                ),
                SizedBox(width: 8.w),
                ProductFeatureCard(
                  title: 'Eco Packaging',
                  subtitle: '100% sustainable',
                  imagePath:
                      'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080733/eco_packing_tajgaw.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductFeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final IconData? icon;

  const ProductFeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 118.w, // Adjust width as needed for layout
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: imagePath,
            width: 30.w,
            height: 30.h,
            fit: BoxFit.contain,
            cacheManager: MyCustomCacheManager.instance,
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
