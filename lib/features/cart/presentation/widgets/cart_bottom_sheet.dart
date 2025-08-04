import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/shared/buttons/custombutton.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';

class CartBottomSheet extends StatelessWidget {
  final double totalPrice;
  final double discount;
  final double finalPrice;
  final VoidCallback? onCheckout;
  final Color? labelColor;
  final Color? valueColor;
  final Color? discountColor;
  final Color? backgroundColor;

  const CartBottomSheet({
    super.key,
    required this.totalPrice,
    required this.discount,
    required this.finalPrice,
    this.onCheckout,
    this.labelColor,
    this.valueColor,
    this.discountColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 0.23.sh,
      padding: AppSizes.paddingAllMd,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusXxxl),
          topRight: Radius.circular(AppSizes.radiusXxxl),
        ),
      ),
      child: Column(
        children: [
          _summaryRow(context, "Total Price", totalPrice),
          _summaryRow(
            context,
            "Discount",
            -discount,
            colorOverride: discountColor ?? Colors.red,
          ),
          Divider(
            thickness: 2,
            height: 15.h,
            //indent: 10.w,
            //endIndent: 10.w,
            radius: BorderRadius.circular(AppSizes.radiusLg),
            color: colorScheme.outline,
          ),
          _summaryRow(
            context,
            "Final Price",
            finalPrice,
            isBold: true,
            colorOverride: colorScheme.primary,
          ),
          SizedBox(height: 12.h),
          CustomButton(
            ontap:
                onCheckout ??
                () {
                  CustomSnackBar.showError(
                    context,
                    'Checkout is not implemented yet.',
                  );
                },
            textColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.primary,
            text: 'Proceed to CheckOut',
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String label,
    double amount, {
    bool isBold = false,
    Color? colorOverride,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: textTheme.bodyMedium?.copyWith(color: colorOverride),
          ),
        ],
      ),
    );
  }
}
