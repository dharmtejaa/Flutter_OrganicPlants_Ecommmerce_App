import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/appcolors.dart';
import 'package:organicplants/shared/widgets/custom_dialog.dart';
import 'package:organicplants/features/profile/presentation/widgets/profile_custom_icon.dart';
import 'package:organicplants/shared/buttons/custombutton.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // Refactor _paymentMethods to ValueNotifier
  final ValueNotifier<List<Map<String, dynamic>>> _paymentMethods =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    // Initialize _paymentMethods with your data
    _paymentMethods.value = [
      {
        'id': '1',
        'type': 'Credit Card',
        'name': 'Visa ending in 1234',
        'icon': Icons.credit_card,
        'color': Colors.blue,
        'isDefault': true,
        'expiry': '12/25',
      },
      {
        'id': '2',
        'type': 'UPI',
        'name': 'john.doe@upi',
        'icon': Icons.account_balance_wallet,
        'color': Colors.purple,
        'isDefault': false,
      },
      {
        'id': '3',
        'type': 'Net Banking',
        'name': 'HDFC Bank',
        'icon': Icons.account_balance,
        'color': Colors.green,
        'isDefault': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Methods", style: textTheme.headlineSmall),

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _paymentMethods,
        builder: (context, paymentMethods, _) {
          return Column(
            children: [
              Expanded(
                child:
                    paymentMethods.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                          padding: EdgeInsets.all(AppSizes.paddingSm),
                          itemCount: paymentMethods.length,
                          itemBuilder: (context, index) {
                            return _buildPaymentMethodCard(
                              paymentMethods[index],
                            );
                          },
                        ),
              ),
              CustomButton(
                width: 350.w,
                backgroundColor: colorScheme.primary,
                text: "Add Payment Method",
                ontap: () => _showAddPaymentMethodDialog(),
                icon: Icons.add,
              ),
              SizedBox(height: AppSizes.paddingMd),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payment_outlined, size: 80.r, color: colorScheme.outline),
          SizedBox(height: 16.h),
          Text("No Payment Methods", style: textTheme.headlineLarge),
          SizedBox(height: 8.h),
          Text(
            "Add a payment method to make purchases",
            style: textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> paymentMethod) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: colorScheme.surface,
      margin: EdgeInsets.only(bottom: AppSizes.radiusMd),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Padding(
        padding: AppSizes.paddingSymmetricSm,
        child: Row(
          children: [
            // Custom icon widget for payment method
            ProfileCustomIcon(
              icon: paymentMethod['icon'],
              iconColor: paymentMethod['color'],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(paymentMethod['type'], style: textTheme.titleLarge),
                      if (paymentMethod['isDefault']) ...[
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text('Default', style: textTheme.labelSmall),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(paymentMethod['name'], style: textTheme.bodyMedium),
                  if (paymentMethod['expiry'] != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Expires: ${paymentMethod['expiry']}',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            PopupMenuButton<String>(
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
              onSelected:
                  (value) => _handlePaymentMethodAction(value, paymentMethod),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'set_default',
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_outline,
                            size: AppSizes.iconSm,
                            color: AppColors.starFilled,
                          ),
                          SizedBox(width: 8.w),
                          Text('Set as Default', style: textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: AppSizes.iconSm,
                            color: AppColors.accent,
                          ),
                          SizedBox(width: 8.w),
                          Text('Edit', style: textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.error,
                            size: AppSizes.iconSm,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Delete',
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentMethodAction(
    String action,
    Map<String, dynamic> paymentMethod,
  ) {
    switch (action) {
      case 'set_default':
        setDefaultPaymentMethod(paymentMethod);
        break;
      case 'edit':
        editPaymentMethod(paymentMethod);
        break;
      case 'delete':
        CustomDialog.showDeleteConfirmation(
          context: context,
          title: 'Delete Payment Method',
          content:
              'Are you sure you want to delete ${paymentMethod['name']}? This action cannot be undone.',
          onDelete: () {
            final updated = List<Map<String, dynamic>>.from(
              _paymentMethods.value,
            );
            updated.removeWhere(
              (method) => method['id'] == paymentMethod['id'],
            );
            _paymentMethods.value = updated;
            CustomSnackBar.showSuccess(
              context,
              'Payment method deleted successfully!',
            );
          },
        );
        break;
    }
  }

  // ignore: unused_element
  void _showAddPaymentMethodDialog() {
    CustomDialog.showCustom(
      context: context,
      title: 'Add Payment Method',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPaymentOption(
            context,
            'Credit/Debit Card',
            Icons.credit_card,
            Colors.blue,
            () => addCreditCard(),
          ),
          _buildPaymentOption(
            context,
            'UPI',
            Icons.account_balance_wallet,
            Colors.purple,
            () => addUPI(),
          ),
          _buildPaymentOption(
            context,
            'Net Banking',
            Icons.account_balance,
            Colors.green,
            () => addNetBanking(),
          ),
          _buildPaymentOption(
            context,
            'Digital Wallet',
            Icons.phone_android,
            Colors.orange,
            () => addDigitalWallet(),
          ),
        ],
      ),
      showCancelButton: false,
      showConfirmButton: false,
      icon: Icons.add_circle_outline_rounded,
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: ProfileCustomIcon(icon: icon, iconColor: color),
      title: Text(title, style: textTheme.bodyMedium),
      onTap: () {
        onTap();
      },
    );
  }

  void addCreditCard() {
    CustomSnackBar.showInfo(context, 'Credit card form coming soon!');
  }

  void addUPI() {
    CustomSnackBar.showInfo(context, 'UPI form coming soon!');
  }

  void addNetBanking() {
    CustomSnackBar.showInfo(context, 'Net banking form coming soon!');
  }

  void addDigitalWallet() {
    CustomSnackBar.showInfo(context, 'Digital wallet form coming soon!');
  }

  void setDefaultPaymentMethod(Map<String, dynamic> paymentMethod) {
    final updated = List<Map<String, dynamic>>.from(_paymentMethods.value);
    for (var method in updated) {
      method['isDefault'] = method['id'] == paymentMethod['id'];
    }
    _paymentMethods.value = updated;
    CustomSnackBar.showInfo(context, 'Payment method set as default!');
  }

  void editPaymentMethod(Map<String, dynamic> paymentMethod) {
    CustomSnackBar.showInfo(context, 'Edit payment method form coming soon!');
  }
}
