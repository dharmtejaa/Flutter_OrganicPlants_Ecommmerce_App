import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/wishlist/logic/wishlist_provider.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:provider/provider.dart';

class WishlistIconButton extends StatelessWidget {
  final double? radius;
  final double? iconSize;
  final String plantId;

  const WishlistIconButton({
    super.key,
    required this.plantId,
    this.radius,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);

    return Consumer<WishlistProvider>(
      builder: (context, value, child) {
        // If plant is not found, return empty container
        if (plant == null) {
          return Container();
        }

        final isWishListed = value.isInWishlist(plant.id ?? '');
        return GestureDetector(
          onTap: () {
            value.toggleWishList(plant.id ?? '');
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder:
                (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
            child: CircleAvatar(
              key: ValueKey<bool>(isWishListed),
              radius: radius ?? 15.r,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                isWishListed ? Icons.favorite : Icons.favorite_border,
                size: iconSize ?? AppSizes.iconMd,
                color: colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
