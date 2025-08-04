import 'package:flutter/material.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/cart/logic/cart_provider.dart';
import 'package:organicplants/features/cart/presentation/screens/cart_screen.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.cartProvider,
    required this.plantId,
  });

  final CartProvider cartProvider;
  final String plantId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);
   
    return GestureDetector(
      onTap: () {
        if (plant == null) {
          CustomSnackBar.showError(context, 'Plant not found');
          return;
        }

        final alreadyInCart = cartProvider.isInCart(plant.id);
        if (!alreadyInCart) {
          cartProvider.addToCart(plant.id ?? '');
        } else {
          CustomSnackBar.showInfo(
            context,
            '${plant.commonName} is already in the cart!',
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
      //borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: AppSizes.paddingAllXs,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.radiusLg),
            bottomRight: Radius.circular(AppSizes.radiusLg),
          ),
          //shape: BoxShape.circle,
          color: colorScheme.primaryContainer,
        ),
        child: Icon(
          Icons.shopping_cart_outlined,
          size: AppSizes.iconMd,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
