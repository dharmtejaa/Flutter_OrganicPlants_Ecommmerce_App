import 'package:flutter/material.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/wishlist/logic/wishlist_provider.dart';
import 'package:organicplants/features/wishlist/presentation/screens/wishlist_screen.dart';
import 'package:provider/provider.dart';

class WishlistIconWithBadge extends StatelessWidget {
  const WishlistIconWithBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WishlistScreen()),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.favorite_border,
                size: AppSizes.iconMd,
                color: colorScheme.onSurface,
              ),
            ],
          ),
        );
      },
    );
  }
}
