import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';

class CustomDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    IconData? icon,
    Color? iconColor,
    Widget? customContent,
    bool barrierDismissible = true,
    bool showCancelButton = true,
    bool showConfirmButton = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            title: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color:
                        iconColor ??
                        (isDestructive
                            ? colorScheme.error
                            : colorScheme.primary),
                    size: 24.r,
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      color:
                          isDestructive
                              ? colorScheme.error
                              : colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            content:
                customContent ??
                Text(
                  content,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            actions: [
              if (showCancelButton) ...[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    onCancel?.call();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: Text(
                    cancelText ?? 'Cancel',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
              if (showConfirmButton) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    onConfirm?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDestructive ? colorScheme.error : colorScheme.primary,
                    foregroundColor:
                        isDestructive
                            ? colorScheme.onError
                            : colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    confirmText ?? (isDestructive ? 'Delete' : 'Confirm'),
                    style: textTheme.labelLarge?.copyWith(
                      color:
                          isDestructive
                              ? colorScheme.onError
                              : colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ],
            actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          ),
    );
  }

  // Convenience method for delete confirmations
  static Future<bool?> showDeleteConfirmation({
    required BuildContext context,
    String? confirmText,
    required String title,
    required String content,
    String? itemName,
    VoidCallback? onDelete,
  }) {
    return show(
      context: context,
      title: title,
      content: content,
      confirmText: confirmText ?? 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
      icon: Icons.delete_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      onConfirm: onDelete,
    );
  }

  // Convenience method for success messages
  static Future<bool?> showSuccess({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      content: content,
      confirmText: confirmText ?? 'OK',
      showCancelButton: false,
      icon: Icons.check_circle_outline_rounded,
      iconColor: Colors.green,
      onConfirm: onConfirm,
    );
  }

  // Convenience method for error messages
  static Future<bool?> showError({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      content: content,
      confirmText: confirmText ?? 'OK',
      showCancelButton: false,
      isDestructive: true,
      icon: Icons.error_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      onConfirm: onConfirm,
    );
  }

  // Convenience method for info messages
  static Future<bool?> showInfo({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      content: content,
      confirmText: confirmText ?? 'OK',
      showCancelButton: false,
      icon: Icons.info_outline_rounded,
      iconColor: Theme.of(context).colorScheme.primary,
      onConfirm: onConfirm,
    );
  }

  // Method for custom content dialogs
  static Future<bool?> showCustom({
    required BuildContext context,
    required String title,
    required Widget content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    IconData? icon,
    Color? iconColor,
    bool barrierDismissible = true,
    bool showCancelButton = true,
    bool showConfirmButton = true,
  }) {
    return show(
      context: context,
      title: title,
      content: '',
      customContent: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDestructive: isDestructive,
      icon: icon,
      iconColor: iconColor,
      barrierDismissible: barrierDismissible,
      showCancelButton: showCancelButton,
      showConfirmButton: showConfirmButton,
    );
  }

  // Method for confirmation dialogs
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
  }) {
    return show(
      context: context,
      title: title,
      content: content,
      confirmText: confirmText ?? 'Confirm',
      cancelText: cancelText ?? 'Cancel',
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: icon ?? Icons.help_outline_rounded,
      iconColor: iconColor ?? Theme.of(context).colorScheme.primary,
    );
  }
}
