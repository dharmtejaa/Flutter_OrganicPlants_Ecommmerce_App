// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/features/entry/presentation/screen/entry_screen.dart';
import 'package:organicplants/features/profile/data/order_history_model.dart';
import 'package:organicplants/features/profile/logic/order_history_provider.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
import 'package:organicplants/features/profile/presentation/screens/order_details_screen.dart';

class UnifiedOrdersScreen extends StatefulWidget {
  final int? initialTabIndex;
  const UnifiedOrdersScreen({super.key, this.initialTabIndex});

  @override
  State<UnifiedOrdersScreen> createState() => _UnifiedOrdersScreenState();
}

class _UnifiedOrdersScreenState extends State<UnifiedOrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All Orders', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    if (widget.initialTabIndex != null) {
      _tabController.index = widget.initialTabIndex!;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders", style: textTheme.headlineMedium),
        actions: [],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          labelStyle: textTheme.titleLarge,
          unselectedLabelStyle: textTheme.titleLarge,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAllOrdersTab(), _buildCancelledTab()],
      ),
    );
  }

  Widget _buildAllOrdersTab() {
    return Consumer<OrderHistoryProvider>(
      builder: (context, orderProvider, child) {
        final orders = orderProvider.orders;

        if (orders.isEmpty) {
          return _buildEmptyState(context, 'All Orders');
        }

        return ListView.builder(
          padding: AppSizes.paddingAllSm,
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return _buildOrderCard(context, orders[index]);
          },
        );
      },
    );
  }

  Widget _buildCancelledTab() {
    return Consumer<OrderHistoryProvider>(
      builder: (context, orderProvider, child) {
        final cancelledOrders =
            orderProvider.orders
                .where((order) => order.status.toLowerCase() == 'cancelled')
                .toList();
        if (cancelledOrders.isEmpty) {
          return _buildEmptyState(context, 'Cancelled');
        }
        return ListView.builder(
          padding: AppSizes.paddingAllMd,
          itemCount: cancelledOrders.length,
          itemBuilder: (context, index) {
            return _buildCancelledOrderCard(context, cancelledOrders[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String tab) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIconForTab(tab), size: 80.r, color: colorScheme.outline),
          SizedBox(height: AppSizes.spaceHeightMd),
          Text(
            "No ${tab.split(' ').last} Found",
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: AppSizes.spaceHeightSm),
          Text(
            "You don't have any ${tab.toLowerCase()} yet",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.spaceHeightLg),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EntryScreen()),
              );
            },
            icon: Icon(
              Icons.shopping_bag,
              size: AppSizes.iconSm,
              color: colorScheme.onPrimary,
            ),
            label: Text(
              "Start Shopping",
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTab(String tab) {
    switch (tab) {
      case 'All Orders':
        return Icons.shopping_bag_outlined;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  Widget _buildOrderCard(BuildContext context, OrderHistoryModel order) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: AppShadows.cardShadow(context),
      ),
      child: Padding(
        padding: AppSizes.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${order.orderId}",
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Placed on ${order.date}",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(context, order.status),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(thickness: 2, color: colorScheme.outline),
            SizedBox(height: 16.h),
            Text(
              "Items",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            ...order.items.map<Widget>(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Text("• ${item.name}", style: textTheme.bodyMedium),
                    Spacer(),
                    Text(
                      "Qty: ${item.quantity}",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(item.price, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text(
                  "Total:",
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Spacer(),
                Text(
                  order.total,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                if (order.status.toLowerCase() != 'cancelled') ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.cancel_outlined, size: 16),
                      label: Text('Cancel Order'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                      onPressed: () {
                        _showCancelOrderDialog(context, order);
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.visibility_outlined, size: 16),
                    label: Text('View Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                    onPressed: () {
                      // Convert OrderHistoryModel to Map for OrderDetailsScreen
                      final orderMap = {
                        'id': order.orderId,
                        'date': order.date,
                        'status': order.status,
                        'total': order.total,
                        'items':
                            order.items
                                .map(
                                  (item) => {
                                    'id': item.plantId ?? '',
                                    'name': item.name,
                                    'quantity': item.quantity,
                                    'price': item.price,
                                    'image': item.imageUrl,
                                  },
                                )
                                .toList(),
                        'deliveryAddress': order.deliveryAddress,
                        'trackingNumber': order.trackingNumber,
                      };

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => OrderDetailsScreen(order: orderMap),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledOrderCard(
    BuildContext context,
    OrderHistoryModel order,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: AppShadows.cardShadow(context),
      ),
      child: Padding(
        padding: AppSizes.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${order.orderId}",
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Cancelled on ${order.date}",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(context, order.status),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(thickness: 2, color: colorScheme.outline),
            SizedBox(height: 10.h),
            Text("Items", style: textTheme.titleLarge),
            SizedBox(height: 8.h),
            ...order.items.map<Widget>(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Text("• ${item.name}", style: textTheme.titleLarge),
                    Spacer(),
                    Text(
                      "Qty: ${item.quantity}",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(item.price, style: textTheme.titleLarge),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text("Total:", style: textTheme.titleLarge),
                Spacer(),
                Text(
                  order.total,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: AppSizes.paddingAllSm,
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: colorScheme.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.error,
                    size: AppSizes.iconSm,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "This order has been cancelled. Refund will be processed according to your selected payment method.",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'delivered':
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case 'in transit':
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        break;
      case 'cancelled':
        backgroundColor = colorScheme.error;
        textColor = colorScheme.onError;
        break;
      case 'returned':
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
      default:
        backgroundColor = colorScheme.outline;
        textColor = colorScheme.onSurface;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: AppShadows.elevatedShadow(context),
      ),
      child: Text(
        status,
        style: textTheme.labelMedium?.copyWith(color: textColor),
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context, OrderHistoryModel order) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    String selectedPaymentMethod = 'Original Payment Method';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Cancel Order',
                style: textTheme.titleLarge?.copyWith(color: colorScheme.error),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to cancel Order #${order.orderId}?',
                    style: textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Select Payment Receive Mode:',
                    style: textTheme.titleLarge,
                  ),
                  SizedBox(height: 8.h),
                  RadioListTile<String>(
                    title: Text(
                      'Original Payment Method',
                      style: textTheme.bodyMedium,
                    ),
                    value: 'Original Payment Method',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),

                  RadioListTile<String>(
                    title: Text('Bank Transfer', style: textTheme.bodyMedium),
                    value: 'Bank Transfer',
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: textTheme.bodyMedium),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Update order status to cancelled
                    final orderProvider = Provider.of<OrderHistoryProvider>(
                      context,
                      listen: false,
                    );

                    // Cancel the order using the provider method
                    await orderProvider.cancelOrder(order.orderId);

                    Navigator.of(context).pop();

                    // Show success message
                    CustomSnackBar.showSuccess(
                      context,
                      'Order cancelled successfully!',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  child: Text('Confirm Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
