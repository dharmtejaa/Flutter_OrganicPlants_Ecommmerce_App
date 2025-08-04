// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/app_shadows.dart';

class SubmitCustomButtons extends StatelessWidget {
  final String? text;

  final String? networkImage;
  final Future<void> Function()? ontap;
  final Color backgroundColor;
  final IconData? icon;
  final Color? textColor;
  //final bool useGradient;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool? isBorder;

  const SubmitCustomButtons({
    super.key,
    this.text,

    this.networkImage,
    this.ontap,
    this.icon,
    required this.backgroundColor,
    this.textColor,
    //this.useGradient = false,
    this.isLoading = false,
    this.isBorder = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    //final isDark = colorScheme.brightness == Brightness.dark;

    return Material(
      elevation: 1,
      child: GestureDetector(
        onTap: isLoading ? null : ontap,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 52.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            //gradient: useGradient ? AppColors.primaryGradient : null,
            color: backgroundColor,
            //boxShadow: AppShadows.cardShadow(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // if (icon != null)
              //   Icon(icon, size: AppSizes.iconMd, color: colorScheme.onPrimary),
              if (networkImage != null && !isLoading)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: CachedNetworkImage(
                    imageUrl: networkImage ?? '',
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.cover,
                    cacheManager: MyCustomCacheManager.instance,
                  ),
                ),
              if (isLoading)
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? colorScheme.onPrimary,
                    ),
                  ),
                ),
              if (text != null && !isLoading)
                Row(
                  children: [
                    if (icon != null)
                      Row(
                        children: [
                          Icon(
                            icon,
                            size: AppSizes.iconMd,
                            color: colorScheme.onPrimary,
                          ),
                          SizedBox(width: 4.w),
                        ],
                      ),

                    Text(
                      text ?? '',
                      style: textTheme.labelLarge?.copyWith(color: textColor),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
