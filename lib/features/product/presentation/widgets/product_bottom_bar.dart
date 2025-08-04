import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/app_theme.dart';
import 'package:organicplants/features/auth/presentation/screens/loginscreen.dart';
import 'package:organicplants/features/cart/logic/cart_provider.dart';
import 'package:organicplants/features/cart/presentation/screens/cart_screen.dart';
import 'package:organicplants/shared/buttons/custombutton.dart';
import 'package:organicplants/shared/buttons/wishlist_icon_button.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:organicplants/shared/logic/user_profile_provider.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:organicplants/features/cart/presentation/screens/checkout_screen.dart';

class ProductBottomBar extends StatelessWidget {
  final String plantId;
  const ProductBottomBar({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);
    final colorScheme = Theme.of(context).colorScheme;
    final cartProvider = Provider.of<CartProvider>(context);
    return Container(
      padding: AppSizes.paddingAllSm,
      decoration: BoxDecoration(
        color: colorScheme.surface,

        //border: Border(top: BorderSide(color: colorScheme.tertiary)),
      ),
      child: Row(
        children: [
          // Favorite button
          WishlistIconButton(
            plantId: plant!.id!,
            iconSize: AppSizes.iconLg,
            radius: AppSizes.radiusXxl,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomButton(
              ontap: () {
                if (!cartProvider.isInCart(plant.id!)) {
                  cartProvider.addToCart(plant.id!);
                } else {
                  CustomSnackBar.showInfo(
                    context,
                    '${plant.commonName} is already in cart',
                    actionLabel: 'View Cart',
                    onAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  );
                }
              },
              backgroundColor: colorScheme.primary,
              icon: Icons.shopping_cart_outlined,
              textColor: colorScheme.onPrimary,
              text: cartProvider.isInCart(plant.id) ? 'In Cart' : 'Add',
              height: 50.h,
              width: 100.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomButton(
              backgroundColor: AppTheme.secondaryColor,
              icon: Icons.flash_on_rounded,
              textColor: colorScheme.onPrimary,
              text: 'Buy Now',
              height: 50.h,
              width: 100.w,
              ontap: () async {
                final userProvider = Provider.of<UserProfileProvider>(
                  context,
                  listen: false,
                );
                final uid = userProvider.currentUser?.uid;
                if (uid == null) {
                  CustomSnackBar.showInfo(
                    context,
                    'Please login to buy this plant',
                    actionLabel: 'Login',
                    onAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Loginscreen()),
                      );
                    },
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CheckoutScreen(buyNowPlantId: plant.id!),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
