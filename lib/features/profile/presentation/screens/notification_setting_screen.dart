import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/profile/presentation/widgets/profile_custom_icon.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:organicplants/shared/widgets/gesture_detector_button.dart';
import 'package:organicplants/shared/widgets/custom_dialog.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Refactor all notification booleans to ValueNotifier
  final ValueNotifier<bool> _orderUpdates = ValueNotifier(false);
  final ValueNotifier<bool> _deliveryReminders = ValueNotifier(false);
  final ValueNotifier<bool> _priceDrops = ValueNotifier(false);
  final ValueNotifier<bool> _newProducts = ValueNotifier(false);
  final ValueNotifier<bool> _plantCareTips = ValueNotifier(false);
  final ValueNotifier<bool> _appUpdates = ValueNotifier(false);
  final ValueNotifier<bool> _promotionalOffers = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications", style: textTheme.headlineMedium),
        actions: [
          GestureDetectorButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "Save",
            textColor: colorScheme.primary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSizes.paddingAllSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Notifications
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 24.h),
                _buildSectionHeader(
                  "Order & Shopping",
                  Icons.shopping_bag_outlined,
                ),
                SizedBox(height: 12.h),
                _buildNotificationTile(
                  "Order Updates",
                  "Get notified about order status changes",
                  Icons.local_shipping_outlined,
                  _orderUpdates,
                ),
                _buildNotificationTile(
                  "Delivery Reminders",
                  "Reminders about upcoming deliveries",
                  Icons.delivery_dining_outlined,
                  _deliveryReminders,
                ),
                _buildNotificationTile(
                  "Price Drops",
                  "Get notified when items in your wishlist go on sale",
                  Icons.trending_down_outlined,
                  _priceDrops,
                ),
                SizedBox(height: 24.h),
                _buildSectionHeader(
                  "Content & Updates",
                  Icons.content_copy_outlined,
                ),
                SizedBox(height: 12.h),
                _buildNotificationTile(
                  "New Products",
                  "Be the first to know about new plant arrivals",
                  Icons.new_releases_outlined,
                  _newProducts,
                ),
                _buildNotificationTile(
                  "Plant Care Tips",
                  "Weekly tips for better plant care",
                  Icons.eco_outlined,
                  _plantCareTips,
                ),
                _buildNotificationTile(
                  "App Updates",
                  "Important app updates and maintenance",
                  Icons.system_update_outlined,
                  _appUpdates,
                ),
                SizedBox(height: 24.h),
                _buildSectionHeader("Promotional", Icons.local_offer_outlined),
                SizedBox(height: 12.h),
                _buildNotificationTile(
                  "Promotional Offers",
                  "Special discounts and promotional offers",
                  Icons.discount_outlined,
                  _promotionalOffers,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Notification Schedule
            _buildSectionHeader(
              "Notification Schedule",
              Icons.schedule_outlined,
            ),
            SizedBox(height: 12.h),

            _buildScheduleCard(),

            SizedBox(height: 24.h),

            // Quick Actions
            _buildSectionHeader("Quick Actions", Icons.flash_on_outlined),
            SizedBox(height: 12.h),

            _buildQuickActionButton(
              "Test Notifications",
              Icons.notifications_active_outlined,
              _testNotifications,
            ),

            _buildQuickActionButton(
              "Clear All Notifications",
              Icons.clear_all_outlined,
              _clearAllNotifications,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: AppSizes.iconSm),
        SizedBox(width: 12.w),
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildNotificationTile(
    String title,
    String subtitle,
    IconData icon,
    ValueNotifier<bool> notifier,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, value, _) {
        return Card(
          margin: EdgeInsets.only(bottom: 8.h),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Padding(
            padding: AppSizes.paddingAllSm,
            child: Row(
              children: [
                ProfileCustomIcon(
                  icon: icon,
                  iconColor: colorScheme.primary,
                  containerSize: 45.sp,
                ),
                SizedBox(width: AppSizes.spaceSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: textTheme.bodyMedium),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                //switch widget
                Transform.scale(
                  scale: 0.9,
                  child: Switch(
                    value: value,
                    onChanged: (val) => notifier.value = val,
                    activeColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleCard() {
    //final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Padding(
        padding: AppSizes.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quiet Hours", style: textTheme.titleLarge),
            SizedBox(height: 12.h),
            Text(
              "Notifications will be silenced during quiet hours (10:00 PM - 8:00 AM)",
              style: textTheme.bodyMedium,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildTimePicker(
                    "Start Time",
                    "10:00 PM",
                    () => _selectStartTime(),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildTimePicker(
                    "End Time",
                    "8:00 AM",
                    () => _selectEndTime(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, String time, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: textTheme.bodyMedium),
                Icon(
                  Icons.access_time,
                  size: AppSizes.iconSm,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      elevation: 1,

      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),

      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        leading: ProfileCustomIcon(
          icon: icon,
          iconColor: colorScheme.onSurface,
        ),
        title: Text(title, style: textTheme.titleMedium),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppSizes.iconXs,
          color: colorScheme.onSurface,
        ),
        onTap: onTap,
      ),
    );
  }

  void _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 22, minute: 0),
    );
    if (picked != null) {
      CustomSnackBar.showInfo(
        // ignore: use_build_context_synchronously
        context,
        // ignore: use_build_context_synchronously
        "Start time updated to ${picked.format(context)}",
      );
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      CustomSnackBar.showInfo(
        // ignore: use_build_context_synchronously
        context,
        // ignore: use_build_context_synchronously
        "End time updated to ${picked.format(context)}",
      );
    }
  }

  void _testNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test notification sent!'),
        action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
      ),
    );
  }

  void _clearAllNotifications() {
    CustomDialog.showConfirmation(
      context: context,
      title: 'Clear All Notifications',
      content:
          'Are you sure you want to clear all notifications? This action cannot be undone.',
      confirmText: 'Clear All',
      cancelText: 'Cancel',
      icon: Icons.clear_all_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      onConfirm: () {
        CustomSnackBar.showSuccess(context, "All notifications cleared!");
      },
    );
  }
}
