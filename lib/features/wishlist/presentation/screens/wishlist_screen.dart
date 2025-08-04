import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/features/cart/presentation/screens/cart_screen.dart';
import 'package:organicplants/features/wishlist/data/wishlist_model.dart';
import 'package:organicplants/features/wishlist/logic/wishlist_provider.dart';
import 'package:organicplants/features/wishlist/presentation/widgets/product_tile.dart';
import 'package:organicplants/shared/buttons/cart_icon_with_batdge.dart';
import 'package:organicplants/shared/buttons/searchbutton.dart';
import 'package:organicplants/shared/widgets/no_result_found.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("My WishList", style: textTheme.headlineMedium),

        actions: [
          SearchButton(),
          SizedBox(width: 8.w),
          CartIconWithBadge(
            iconColor: colorScheme.onSurface,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          final wishlistItems = wishlistProvider.wishlistItems;
          return wishlistItems.isEmpty
              ? Center(
                child: NoResultsFound(
                  title: "Your Wishlist is empty",
                  message: "Add some plants to get started!",
                  imagePath:
                      "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080574/No_Plant_Found_dmdjsy.png",
                ),
              )
              : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  final WishlistItemModel item = wishlistItems[index];
                  return ProductTile(plantId: item.plantId);
                },
              );
        },
      ),
    );
  }
}
