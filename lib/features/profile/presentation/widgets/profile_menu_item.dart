import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/app_shadows.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon; // will be ignored
  final Color? iconColor; // will be ignored
  final Color? backgroundColor; // will be ignored
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showDivider;
  final bool isDestructive;

  const ProfileMenuItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.trailing,
    this.showDivider = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: Material(
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          onTap: onTap,
          child: Padding(
            padding: AppSizes.paddingAllSm,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: textTheme.bodyMedium),
                      if (subtitle != null) ...[
                        SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: AppSizes.spaceSm),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Specialized menu items for common use cases
class ProfileMenuSection extends StatelessWidget {
  final Color? color;
  final String? title;
  final List<ProfileMenuItem> items;

  const ProfileMenuSection({
    super.key,
    this.title,
    required this.items,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: AppShadows.cardShadow(context),
      ),
      padding: AppSizes.paddingAllSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              if (title != null) ...[
                Text(
                  title!,
                  style: textTheme.titleLarge?.copyWith(color: color),
                ),
              ],
            ],
          ),
          SizedBox(height: 15.h),
          ...items,
        ],
      ),
    );
  }
}
