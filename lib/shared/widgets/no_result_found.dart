import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';

class NoResultsFound extends StatelessWidget {
  final String title;
  final String message;
  final String imagePath;

  const NoResultsFound({
    super.key,
    required this.title,
    required this.message,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // ignore: non_constant_identifier_names
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 0.15.sh),
        CachedNetworkImage(
          imageUrl: imagePath,
          height: 0.33.sh,
          errorWidget:
              (context, error, stackTrace) => Icon(
                Icons.error_outline,
                size: 100,
                color: colorScheme.error,
              ),
          cacheManager: MyCustomCacheManager.instance,
        ),
        SizedBox(height: 10.h),
        Text(
          title,
          style: textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
