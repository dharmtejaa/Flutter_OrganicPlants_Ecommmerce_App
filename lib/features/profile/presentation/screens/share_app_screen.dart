import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Share App', style: textTheme.headlineMedium),
       
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
            size: AppSizes.iconMd,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: AppSizes.paddingAllSm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.share,
                color: colorScheme.primary,
                size: AppSizes.iconXl,
              ),
              SizedBox(height: 24.h),
              Text(
                'Share Organic Plants with your friends and family!',
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'Help us grow our community by inviting others to discover and enjoy beautiful plants. Thank you for supporting us!',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    CustomSnackBar.showInfo(
                      context,
                      'Share functionality coming soon!',
                    );
                  },
                  icon: Icon(Icons.share, size: AppSizes.iconSm),
                  label: Text('Share Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
