import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/cart/logic/cart_provider.dart';
import 'package:provider/provider.dart';

class CartIconWithBadge extends StatelessWidget {
  final Color? iconColor;
  final Color? badgeColor;
  final VoidCallback? onPressed;

  const CartIconWithBadge({
    super.key,
    this.iconColor,
    this.badgeColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartCount = cartProvider.cartItemsCount;

        Widget icon = GestureDetector(
          onTap: onPressed,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: AppSizes.iconMd,
                color: iconColor ?? colorScheme.onSurface,
              ),
              if (cartCount > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                    child: CircleAvatar(
                      key: ValueKey<int>(cartCount),
                      radius: 8.r,
                      backgroundColor: badgeColor ?? colorScheme.primary,
                      child: Text(
                        '$cartCount',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );

        if (onPressed != null) {
          return InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Padding(padding: const EdgeInsets.all(4.0), child: icon),
          );
        }

        return icon;
      },
    );
  }
}
