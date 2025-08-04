import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/theme/app_theme.dart';
import 'package:organicplants/features/auth/presentation/screens/loginscreen.dart';
import 'package:organicplants/features/cart/data/cart_model.dart';
import 'package:organicplants/features/cart/logic/cart_provider.dart';
import 'package:organicplants/features/cart/presentation/widgets/card_tile.dart';
import 'package:organicplants/features/cart/presentation/widgets/cart_bottom_sheet.dart';
import 'package:organicplants/features/cart/presentation/screens/checkout_screen.dart';
import 'package:organicplants/shared/buttons/searchbutton.dart';
import 'package:organicplants/shared/buttons/wishlist_icon_with_badge.dart';
import 'package:organicplants/shared/logic/user_profile_provider.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:organicplants/shared/widgets/no_result_found.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.itemList;

        // ignore: deprecated_member_use
        return Scaffold(
          appBar: AppBar(
            //automaticallyImplyLeading: false,
            title: Text("My cart", style: textTheme.headlineMedium),

            actions: [
              SearchButton(),
              SizedBox(width: 10.w),
              WishlistIconWithBadge(),
              SizedBox(width: 10.w),
            ],
          ),

          body:
              cartItems.isEmpty
                  ? Center(
                    child: NoResultsFound(
                      imagePath:
                          "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080574/No_Plant_Found_dmdjsy.png",
                      title: "Your cart is empty",
                      message: "Add some plants to get started!",
                    ),
                  )
                  : Padding(
                    padding: EdgeInsets.only(
                      bottom: 190.h,
                      top: 8.h,
                      left: 8.w,
                      right: 8.w,
                    ),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: cartItems.length,
                      itemExtent: 112.h,
                      itemBuilder: (context, index) {
                        final CartItemModel item = cartItems[index];
                        return CardTile(plantId: item.plantId);
                      },
                    ),
                  ),
          bottomSheet:
              cartItems.isNotEmpty
                  ? CartBottomSheet(
                    totalPrice: cartProvider.totalOriginalPrice,
                    discount: -cartProvider.totalDiscount,
                    finalPrice: cartProvider.totalOfferPrice,
                    backgroundColor: colorScheme.surface,
                    discountColor: AppTheme.offerColor,
                    labelColor: colorScheme.onSurface,
                    valueColor: colorScheme.onSurface,
                    onCheckout: () {
                      final userProvider = Provider.of<UserProfileProvider>(
                        context,
                        listen: false,
                      );
                      final uid = userProvider.currentUser?.uid;
                      if (uid == null) {
                        CustomSnackBar.showInfo(
                          context,
                          'Please login to checkout',
                          actionLabel: 'Login',
                          onAction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Loginscreen(),
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CheckoutScreen(
                                  cartItems: cartItems,
                                  totalOriginalPrice:
                                      cartProvider.totalOriginalPrice,
                                  totalOfferPrice: cartProvider.totalOfferPrice,
                                  totalDiscount: cartProvider.totalDiscount,
                                ),
                          ),
                        );
                      }
                    },
                  )
                  : null,
        );
      },
    );
  }
}
