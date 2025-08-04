import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service', style: textTheme.headlineMedium),
      ),
      body: Padding(
        padding: AppSizes.paddingAllSm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Terms of Service', style: textTheme.headlineMedium),
              SizedBox(height: 18.h),
              Text(
                'Please read these Terms of Service ("Terms") carefully before using our app. By accessing or using the app, you agree to be bound by these Terms.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 18.h),
              Text('1. Acceptance of Terms', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              _buildBullet(
                textTheme,
                'By using this app, you agree to comply with and be legally bound by these Terms.',
              ),
              SizedBox(height: 18.h),
              Text('2. User Responsibilities', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              _buildBullet(
                textTheme,
                'Use the app in accordance with all applicable laws and regulations.',
              ),
              _buildBullet(
                textTheme,
                'Do not misuse, disrupt, or attempt to gain unauthorized access to the app or its services.',
              ),
              _buildBullet(
                textTheme,
                'Provide accurate and up-to-date information when required.',
              ),
              SizedBox(height: 18.h),
              Text('3. Intellectual Property', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              _buildBullet(
                textTheme,
                'All content, trademarks, and data on this app are the property of Organic Plants or its licensors.',
              ),
              _buildBullet(
                textTheme,
                'You may not copy, reproduce, or distribute any part of the app without permission.',
              ),
              SizedBox(height: 18.h),
              Text('4. Limitation of Liability', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              _buildBullet(
                textTheme,
                'We are not liable for any damages or losses resulting from your use of the app.',
              ),
              _buildBullet(
                textTheme,
                'The app is provided "as is" without warranties of any kind.',
              ),
              SizedBox(height: 18.h),
              Text('5. Modifications to Terms', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(
                'We reserve the right to update or change these Terms at any time. Continued use of the app after changes constitutes acceptance of the new Terms.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 18.h),
              Text('6. Termination', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(
                'We may suspend or terminate your access to the app at our discretion, without notice, for conduct that we believe violates these Terms or is harmful to other users of the app.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 18.h),
              Text('7. Governing Law', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(
                'These Terms are governed by and construed in accordance with the laws of your jurisdiction.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 18.h),
              Text('8. Contact Us', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(
                'If you have any questions or concerns about these Terms, please contact us at support@organicplants.app.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBullet(TextTheme textTheme, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: textTheme.bodyMedium),
          Expanded(child: Text(text, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
