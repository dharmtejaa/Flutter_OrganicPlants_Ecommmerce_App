// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
import 'package:organicplants/features/cart/data/cart_model.dart';
import 'package:organicplants/features/cart/logic/cart_provider.dart';
import 'package:organicplants/features/profile/data/address_model.dart';
import 'package:organicplants/features/profile/logic/address_provider.dart';
import 'package:organicplants/features/profile/logic/order_history_provider.dart';
import 'package:organicplants/features/profile/presentation/screens/add_edit_address_screen.dart';
import 'package:organicplants/features/profile/presentation/screens/addresses_screen.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class CheckoutScreen extends StatefulWidget {
  final String? buyNowPlantId;
  final List<CartItemModel>? cartItems;
  final double? totalOriginalPrice;
  final double? totalOfferPrice;
  final double? totalDiscount;
  const CheckoutScreen({
    super.key,
    this.buyNowPlantId,
    this.cartItems,
    this.totalOriginalPrice,
    this.totalOfferPrice,
    this.totalDiscount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final List<CartItemModel> cartItems;
  AddressModel? selectedAddress;

  // Refactor selectedPayment to ValueNotifier
  final ValueNotifier<String> selectedPayment = ValueNotifier('');
  final List<String> paymentMethods = [
    'Cash on Delivery',
    'UPI',
    'Credit/Debit Card',
  ];

  final ValueNotifier<bool> isPlacingOrder = ValueNotifier(false);

  int get totalPrice =>
      widget.totalOfferPrice?.toInt() ??
      cartItems.fold(
        0,
        (sum, item) => sum + ((item.offerPrice.toInt()) * (item.quantity)),
      );

  @override
  void initState() {
    super.initState();
    if (widget.buyNowPlantId != null) {
      final AllPlantsModel? plant = AllPlantsGlobalData.getById(
        widget.buyNowPlantId ?? '',
      );
      if (plant != null) {
        cartItems = [
          CartItemModel(
            plantId: plant.id ?? '',
            plantName: plant.commonName ?? '',
            imageUrl:
                plant.images?.isNotEmpty == true
                    ? plant.images?.first.url ?? ''
                    : '',
            originalPrice: (plant.prices?.originalPrice ?? 0).toDouble(),
            offerPrice: (plant.prices?.offerPrice ?? 0).toDouble(),
            discount: 0.0,
            rating: (plant.rating ?? 0).toDouble(),
            quantity: 1,
          ),
        ];
      } else {
        cartItems = [];
      }
    } else if (widget.cartItems != null) {
      cartItems = widget.cartItems!;
    } else {
      cartItems = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: textTheme.headlineMedium),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.radiusSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Summary
                Text('Order Summary', style: textTheme.headlineSmall),
                SizedBox(height: 10.h),
                _buildCartSummary(colorScheme, textTheme),
                SizedBox(height: 16.h),
                // Delivery Address
                _buildSectionHeader(
                  textTheme,
                  'Delivery Address',
                  Icons.location_on,
                  colorScheme,
                ),
                _buildAddressSection(colorScheme, textTheme),
                SizedBox(height: 16.h),
                // Payment Method
                _buildSectionHeader(
                  textTheme,
                  'Payment Method',
                  Icons.payment,
                  colorScheme,
                ),
                _buildPaymentMethods(colorScheme, textTheme),
                SizedBox(height: 20.h),
                // Total and Place Order
                _buildTotalAndButton(colorScheme, textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartSummary(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: AppShadows.cardShadow(context),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: CachedNetworkImage(
                height: 45.h,
                width: 45.w,
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                cacheManager: MyCustomCacheManager.instance,
              ),
            ),
            title: Text(item.plantName, style: textTheme.titleMedium),
            subtitle: Text(
              'Qty: ${item.quantity}',
              style: textTheme.bodyMedium,
            ),
            trailing: Text(
              '₹${item.offerPrice.toInt() * item.quantity}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    TextTheme textTheme,
    String title,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: AppSizes.iconSm),
        SizedBox(width: AppSizes.radiusSm),
        Text(title, style: textTheme.titleLarge),
      ],
    );
  }

  Widget _buildAddressSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        final addresses = addressProvider.address;
        final selectedAddress =
            addressProvider.selectedAddress ?? addressProvider.defaultAddress;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 10.h, top: 10.h),
          padding: AppSizes.paddingAllSm,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: AppShadows.cardShadow(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: colorScheme.primary,
                        size: AppSizes.iconSm,
                      ),
                      SizedBox(width: 8.w),
                      Text('Delivery Address', style: textTheme.titleMedium),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditAddressScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.add, size: 16),
                    label: Text('Add New'),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              if (selectedAddress != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.home,
                      color: colorScheme.primary,
                      size: AppSizes.iconSm,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedAddress.fullName,
                            style: textTheme.titleMedium,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${selectedAddress.house}, ${selectedAddress.street}',
                            style: textTheme.bodySmall,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${selectedAddress.city}, ${selectedAddress.state}',
                            style: textTheme.bodySmall,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            selectedAddress.phoneNumber,
                            style: textTheme.bodySmall,
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              selectedAddress.addressType,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressesScreen(),
                            ),
                          );
                        } else if (value == 'select') {
                          _showAddressSelectionDialog(
                            context,
                            addresses,
                            addressProvider,
                          );
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'select',
                              child: Row(
                                children: [
                                  Icon(Icons.list, size: 16),
                                  SizedBox(width: 8.w),
                                  Text('Select Address'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 16),
                                  SizedBox(width: 8.w),
                                  Text('Manage Addresses'),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
              ] else ...[
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 48,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'No address selected',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showAddressSelectionDialog(
    BuildContext context,
    List<AddressModel> addresses,
    AddressProvider addressProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Delivery Address'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return ListTile(
                  leading: Icon(Icons.home),
                  title: Text(address.fullName),
                  subtitle: Text(
                    '${address.house}, ${address.street}\n${address.city}, ${address.state}',
                  ),
                  trailing:
                      addressProvider.selectedAddress?.addressId ==
                              address.addressId
                          ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                          : null,
                  onTap: () {
                    addressProvider.setSelectedAddress(address);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentMethods(ColorScheme colorScheme, TextTheme textTheme) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedPayment,
      builder: (context, payment, _) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 10.h, top: 10.h),
          padding: AppSizes.paddingAllSm,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: AppShadows.cardShadow(context),
          ),
          child: Column(
            children:
                paymentMethods.map((method) {
                  return RadioListTile<String>(
                    value: method,
                    groupValue: payment,
                    onChanged: (value) {
                      if (value != null) selectedPayment.value = value;
                    },
                    title: Text(method, style: textTheme.bodyMedium),
                    activeColor: colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTotalAndButton(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '₹$totalPrice',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        ValueListenableBuilder<bool>(
          valueListenable: isPlacingOrder,
          builder: (context, placing, _) {
            if (placing) {
              return SizedBox(
                width: 25.w,
                height: 25.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              );
            } else {
              return ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(minimumSize: Size(350.w, 48.h)),
                child: Text('Place Order'),
              );
            }
          },
        ),
      ],
    );
  }

  void _placeOrder() async {
    final addressProvider = Provider.of<AddressProvider>(
      context,
      listen: false,
    );
    final selectedAddress =
        addressProvider.selectedAddress ?? addressProvider.defaultAddress;

    if (selectedAddress == null) {
      CustomSnackBar.showError(context, 'Please select a delivery address');
      return;
    }

    if (selectedPayment.value.isEmpty) {
      CustomSnackBar.showError(context, 'Please select a payment method');
      return;
    }

    isPlacingOrder.value = true;
    await Future.delayed(Duration(seconds: 2));
    isPlacingOrder.value = false;
    if (mounted) {
      // Add order to OrderHistoryProvider
      final orderHistoryProvider = Provider.of<OrderHistoryProvider>(
        context,
        listen: false,
      );
      final order = orderHistoryProvider.createOrderFromCart(
        cartItems:
            cartItems
                .map(
                  (item) => {
                    'name': item.plantName,
                    'quantity': item.quantity,
                    'price': '₹${item.offerPrice.toInt()}',
                    'plantId': item.plantId,
                    'imageUrl': item.imageUrl,
                  },
                )
                .toList(),
        deliveryAddress:
            '${selectedAddress.house}, ${selectedAddress.street}, ${selectedAddress.city}, ${selectedAddress.state}',
        total: '₹$totalPrice',
      );

      orderHistoryProvider.addOrder(order);

      // Clear the cart after successful order placement (only for regular cart checkout, not Buy Now)
      if (widget.buyNowPlantId == null) {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        cartProvider.clearCart();
      }

      final textTheme = Theme.of(context).textTheme;
      final colorScheme = Theme.of(context).colorScheme;

      // Show success dialog with animation based on payment method
      // Debug print
      final isCashOnDelivery =
          selectedPayment.value.trim() == 'Cash on Delivery';
      // Debug print
      final successTitle =
          isCashOnDelivery
              ? 'Order Placed Successfully!'
              : 'Payment Successful!';
      final successMessage =
          isCashOnDelivery
              ? 'Your order has been placed successfully. Pay when you receive your order.'
              : 'Your order has been placed successfully.';

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Dialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Padding(
                padding: AppSizes.paddingAllSm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.network(
                      //width: 320.w,
                      height: 220.h,
                      'https://res.cloudinary.com/daqvdhmw8/raw/upload/v1753080800/successful_toc6py.json', // Use your confetti/sprinkle animation here
                      repeat: false,
                    ),
                    //SizedBox(height: 16),
                    Text(
                      successTitle,
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      successMessage,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(10.w, 10.h),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
      );
    }
  }
}
