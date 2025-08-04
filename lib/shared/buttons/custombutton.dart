import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final String? networkImage;
  final VoidCallback? ontap;
  final Color backgroundColor;
  final IconData? icon;
  final Color? textColor;
  //final bool useGradient;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool? isBorder;

  const CustomButton({
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
              if (networkImage != null)
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
