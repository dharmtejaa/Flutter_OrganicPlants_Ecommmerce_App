// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
import 'package:organicplants/features/product/presentation/screens/product_screen.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        padding: AppSizes.paddingAllSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Card(
              shadowColor: colorScheme.shadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: AppSizes.paddingAllSm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order['id']}',
                      style: textTheme.headlineSmall,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Placed on ${order['date']}',
                      style: textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text('Status: ', style: textTheme.bodyMedium),
                        _buildStatusChip(
                          order['status'],
                          colorScheme,
                          textTheme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Product List
            Text('Products', style: textTheme.headlineSmall),
            SizedBox(height: 8.h),
            ...List.generate(order['items'].length, (index) {
              final item = order['items'][index];
              return GestureDetector(
                onTap: () {
                  // Try to find the plant by id or name
                  final plant = allPlantsGlobal.firstWhereOrNull(
                    (p) => p.id == item['id'] || p.commonName == item['name'],
                  );
                  if (plant != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductScreen(plantId: plant.id!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Product details not found.')),
                    );
                  }
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: AppSizes.paddingAllSm,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Enhanced Product image
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMd,
                            ),
                            boxShadow: AppShadows.cardShadow(context),
                          ),
                          child:
                              item['image'] != null &&
                                      item['image'].toString().isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusMd,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: item['image'],
                                      fit: BoxFit.cover,
                                      width: 80.w,
                                      height: 80.w,
                                      cacheManager:
                                          MyCustomCacheManager.instance,
                                      placeholder:
                                          (context, url) => Container(
                                            color:
                                                colorScheme
                                                    .surfaceContainerHighest,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            color:
                                                colorScheme
                                                    .surfaceContainerHighest,
                                            child: Icon(
                                              Icons.local_florist,
                                              size: 40.r,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                    ),
                                  )
                                  : (() {
                                    final plant = allPlantsGlobal
                                        .firstWhereOrNull(
                                          (p) =>
                                              p.id == item['id'] ||
                                              p.commonName == item['name'],
                                        );
                                    if (plant != null &&
                                        plant.images != null &&
                                        plant.images!.isNotEmpty) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusMd,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              plant.images!.first.url ?? '',
                                          fit: BoxFit.cover,
                                          width: 80.w,
                                          height: 80.w,
                                          cacheManager:
                                              MyCustomCacheManager.instance,
                                          placeholder:
                                              (context, url) => Container(
                                                color:
                                                    colorScheme
                                                        .surfaceContainerHighest,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            colorScheme.primary,
                                                      ),
                                                ),
                                              ),
                                          errorWidget:
                                              (
                                                context,
                                                url,
                                                error,
                                              ) => Container(
                                                color:
                                                    colorScheme
                                                        .surfaceContainerHighest,
                                                child: Icon(
                                                  Icons.local_florist,
                                                  size: 40.r,
                                                  color: colorScheme.primary,
                                                ),
                                              ),
                                        ),
                                      );
                                    }
                                    return Container(
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                      child: Icon(
                                        Icons.local_florist,
                                        size: 40.r,
                                        color: colorScheme.primary,
                                      ),
                                    );
                                  })(),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: textTheme.titleLarge,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusSm,
                                      ),
                                    ),
                                    child: Text(
                                      'Qty: ${item['quantity']}',
                                      style: textTheme.labelMedium?.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                item['price'],
                                style: textTheme.titleLarge?.copyWith(
                                  color: colorScheme.primary,
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
            }),
            SizedBox(height: 16.h),
            // Order Total
            Row(
              children: [
                Text('Order Total:', style: textTheme.headlineSmall),
                Spacer(),
                Text(
                  order['total'],
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Delivery Info (if available)
            if (order['deliveryAddress'] != null) ...[
              Text('Delivery Address', style: textTheme.headlineSmall),
              SizedBox(height: 8.h),
              Text(
                order['deliveryAddress'],
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              SizedBox(height: 16.h),
            ],
            if (order['estimatedDelivery'] != null) ...[
              Text('Estimated Delivery', style: textTheme.headlineSmall),
              SizedBox(height: 8.h),
              Text(order['estimatedDelivery'], style: textTheme.bodyMedium),
            ],
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    String status,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    Color backgroundColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'delivered':
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case 'in transit':
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        break;
      case 'cancelled':
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case 'returned':
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
      default:
        backgroundColor = colorScheme.outline;
        textColor = colorScheme.onSurface;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status,
        style: textTheme.labelMedium?.copyWith(color: textColor),
      ),
    );
  }
}
