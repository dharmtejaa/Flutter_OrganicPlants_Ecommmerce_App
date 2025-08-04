import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';

import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
import 'package:organicplants/features/cart/logic/cart_provider.dart';
import 'package:organicplants/features/product/presentation/screens/product_screen.dart';
import 'package:organicplants/features/search/logic/search_screen_provider.dart';
import 'package:organicplants/features/wishlist/logic/wishlist_provider.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:organicplants/shared/buttons/add_to_cart_button.dart';
import 'package:organicplants/shared/buttons/wishlist_icon_button.dart';
import 'package:provider/provider.dart';

class ProductCardGrid extends StatelessWidget {
  final String plantId;
  final bool? scifiname;

  const ProductCardGrid({super.key, required this.plantId, this.scifiname});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );
    final searchProvider = Provider.of<SearchScreenProvider>(
      context,
      listen: false,
    );
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);

    // If plant is not found, return empty container
    if (plant == null) {
      return Container();
    }

    final offerPrice = (plant.prices?.offerPrice ?? 0).toInt();
    final originalPrice = (plant.prices?.originalPrice ?? 0).toInt();
    final discountPercent =
        originalPrice > 0
            ? ((originalPrice - offerPrice) / originalPrice) * 100
            : 0;
    final discount = discountPercent.toInt().toString();
    final cardWidth = AppSizes.homeProductCardWidth;
    final imageHeight = cardWidth * 0.85;

    return GestureDetector(
      onTap: () {
        searchProvider.addRecentlyViewedPlant(plant.id ?? '');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(plantId: plant.id ?? ''),
          ),
        );
      },
      onDoubleTap: () {
        wishlistProvider.toggleWishList(plant.id ?? '');
      },
      child: Container(
        //margin: EdgeInsets.only(bottom: AppSizes.vMarginXs),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.productCardRadius),
          boxShadow: AppShadows.cardShadow(context),
        ),
        //padding: EdgeInsets.all(5),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image section
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        child: CachedNetworkImage(
                          imageUrl:
                              plant.images?.isNotEmpty == true
                                  ? plant.images?.first.url ?? ''
                                  : '',
                          width: double.infinity,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          errorWidget:
                              (_, __, ___) => Container(
                                height: imageHeight,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusSm,
                                  ),
                                ),
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  size: AppSizes.iconLg,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                          cacheManager: MyCustomCacheManager.instance,
                        ),
                      ),
                      Positioned(
                        top: 4.h,
                        left: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 12.r,
                                color: colorScheme.primary,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                plant.rating?.toStringAsFixed(1) ?? '0.0',
                                style: textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Wishlist icon
                      Positioned(
                        top: 4,
                        right: 4,
                        child: WishlistIconButton(plantId: plant.id ?? ''),
                      ),
                    ],
                  ),

                  // Text Info section
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 5.w, top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          plant.commonName ?? 'Unknown Plant',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: textTheme.titleLarge,
                        ),
                        SizedBox(height: AppSizes.spaceXs),
                        Row(
                          children: [
                            if (originalPrice > offerPrice)
                              Text(
                                '₹$originalPrice',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            if (originalPrice > offerPrice)
                              SizedBox(width: 0.02.sw),
                            Text(
                              '₹$offerPrice',
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.002.sh),
                        if (originalPrice > offerPrice)
                          Text('$discount% off', style: textTheme.bodySmall),
                        SizedBox(height: 0.004.sh),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Add to Cart Button
            Positioned(
              bottom: 0, //-AppSizes.spaceXs,
              right: 0, //-AppSizes.spaceXs,
              child: AddToCartButton(
                cartProvider: cartProvider,
                plantId: plant.id ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
