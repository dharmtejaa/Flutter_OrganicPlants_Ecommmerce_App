import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/appcolors.dart';
import 'package:organicplants/features/cart/logic/cart_provider.dart';
import 'package:organicplants/features/product/presentation/screens/product_screen.dart';
import 'package:organicplants/features/search/logic/search_screen_provider.dart';
import 'package:organicplants/features/wishlist/logic/wishlist_provider.dart';
import 'package:organicplants/shared/buttons/add_to_cart_button.dart';
import 'package:organicplants/shared/buttons/wishlist_icon_button.dart';
import 'package:provider/provider.dart';

class SimplePlantCard extends StatelessWidget {
  final dynamic plant;
  const SimplePlantCard({super.key, required this.plant});

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

    final offerPrice = (plant.prices?.offerPrice ?? 0).toInt();
    final originalPrice = (plant.prices?.originalPrice ?? 0).toInt();
    final discountPercent =
        originalPrice > 0
            ? ((originalPrice - offerPrice) / originalPrice) * 100
            : 0;
    final discount = discountPercent.toInt().toString();
    return GestureDetector(
      //borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      onTap: () {
        searchProvider.addRecentlyViewedPlant(plant);
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
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.productCardRadius),
          boxShadow: [
            BoxShadow(
              color:
                  colorScheme.brightness == Brightness.dark
                      // ignore: deprecated_member_use
                      ? Colors.black.withOpacity(0.1)
                      // ignore: deprecated_member_use
                      : Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSizes.paddingXs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant Image with Rating
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                            color: colorScheme.surfaceContainerHighest,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                            child:
                                plant.images?.isNotEmpty == true
                                    ? CachedNetworkImage(
                                      imageUrl: plant.images?.first.url ?? '',
                                      fit: BoxFit.cover,
                                      cacheManager:
                                          MyCustomCacheManager.instance,

                                      errorWidget: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return CachedNetworkImage(
                                          imageUrl:
                                              'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080574/No_Plant_Found_dmdjsy.png',
                                          fit: BoxFit.cover,
                                          cacheManager:
                                              MyCustomCacheManager.instance,
                                        );
                                      },
                                    )
                                    : CachedNetworkImage(
                                      imageUrl:
                                          'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080574/No_Plant_Found_dmdjsy.png',
                                      fit: BoxFit.cover,
                                      cacheManager:
                                          MyCustomCacheManager.instance,
                                    ),
                          ),
                        ),
                        // Rating Badge
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
                                  '${plant.rating?.toStringAsFixed(1) ?? '0.0'}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: WishlistIconButton(plantId: plant.id ?? ''),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Plant Name
                  Text(
                    plant.commonName ?? 'Unknown Plant',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textTheme.titleLarge,
                  ),
                  SizedBox(height: 4.h),
                  // Plant Price with Original Price
                  Row(
                    children: [
                      if (originalPrice > offerPrice)
                        Text(
                          '₹$originalPrice',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.mutedText,
                          ),
                        ),
                      if (originalPrice > offerPrice) SizedBox(width: 0.02.sw),
                      Text(
                        '₹$offerPrice',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.002.sh),
                  Text('$discount% off', style: textTheme.bodySmall),
                ],
              ),
            ),
            Positioned(
              bottom: 2, //-AppSizes.spaceXs,
              right: 2, //-AppSizes.spaceXs,
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
