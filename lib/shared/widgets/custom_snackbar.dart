import 'package:flutter/material.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/appcolors.dart';
import 'package:organicplants/core/theme/app_shadows.dart';

class CustomSnackBar {
  static void showSuccess(
    BuildContext context,
    String message, {
    String? plantName,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_rounded,
      plantName: plantName,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    String? plantName,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: AppColors.error,
      icon: Icons.error_rounded,
      plantName: plantName,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    String? plantName,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: AppColors.info,
      icon: Icons.info_rounded,
      plantName: plantName,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? plantName,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showSnackBar(
      context,
      message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_rounded,
      plantName: plantName,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
    String? plantName,
    String? actionLabel,
    VoidCallback? onAction,
    required Duration duration,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: AppSizes.elevation,
        margin: AppSizes.marginSymmetricMd,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
        content: Row(
          children: [
            // Enhanced Icon with background
            Container(
              padding: AppSizes.paddingAllSm,
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(
                icon,
                color: colorScheme.onPrimary,
                size: AppSizes.iconSm,
              ),
            ),

            SizedBox(width: AppSizes.spaceMd),

            // Message with highlighted plant name
            Expanded(
              child:
                  plantName != null && message.contains(plantName)
                      ? RichText(
                        text: TextSpan(
                          children: _buildHighlightedText(
                            textTheme,
                            message,
                            plantName,
                            colorScheme,
                            context,
                          ),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                      : Text(
                        message,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
            ),

            // Enhanced Action Button (if provided)
            if (actionLabel != null && onAction != null) ...[
              SizedBox(width: AppSizes.spaceMd),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: AppSizes.paddingSymmetricSm,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    boxShadow: AppShadows.elevatedShadow(context),
                  ),
                  child: Text(
                    actionLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static List<TextSpan> _buildHighlightedText(
    TextTheme textTheme,
    String message,
    String plantName,
    ColorScheme colorScheme,
    BuildContext context,
  ) {
    final List<TextSpan> spans = [];
    final String lowerMessage = message.toLowerCase();
    final String lowerPlantName = plantName.toLowerCase();
    final int startIndex = lowerMessage.indexOf(lowerPlantName);

    if (startIndex == -1) {
      spans.add(TextSpan(text: message));
      return spans;
    }
    // Add text before the plant name
    if (startIndex > 0) {
      spans.add(TextSpan(text: message.substring(0, startIndex)));
    }
    // Add highlighted plant name
    spans.add(
      TextSpan(
        text: message.substring(startIndex, startIndex + plantName.length),
      ),
    );

    // Add text after the plant name
    if (startIndex + plantName.length < message.length) {
      spans.add(
        TextSpan(text: message.substring(startIndex + plantName.length)),
      );
    }
    return spans;
  }
}
