import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: textTheme.headlineMedium),
      ),
      body: Padding(
        padding: AppSizes.paddingAllSm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Privacy Policy', style: textTheme.headlineMedium),
              SizedBox(height: 18.h),
              Text(
                'Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 18.h),
              Text('1. Information We Collect', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(
                'We may collect the following types of information:',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 6.h),
              _buildBullet(
                textTheme,
                'Personal Information (e.g., name, email address, phone number)',
              ),
              _buildBullet(
                textTheme,
                'Usage Data (e.g., app interactions, preferences)',
              ),
              _buildBullet(
                textTheme,
                'Device Information (e.g., device model, OS version)',
              ),
              SizedBox(height: 18.h),
              Text(
                '2. How We Use Your Information',
                style: textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              _buildBullet(textTheme, 'To provide and maintain our services'),
              _buildBullet(
                textTheme,
                'To improve user experience and app functionality',
              ),
              _buildBullet(
                textTheme,
                'To send notifications and updates (with your consent)',
              ),
              _buildBullet(
                textTheme,
                'To respond to your inquiries and support requests',
              ),
              SizedBox(height: 18.h),
              Text(
                '3. Data Sharing & Disclosure',
                style: textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              Text(
                'We do not sell your personal information. We may share your data only in the following cases:',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 6.h),
              _buildBullet(
                textTheme,
                'With service providers who help us operate the app',
              ),
              _buildBullet(textTheme, 'To comply with legal obligations'),
              _buildBullet(
                textTheme,
                'To protect the rights and safety of users and the app',
              ),
              SizedBox(height: 18.h),
              Text('4. Data Security', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(
                'We implement reasonable security measures to protect your information. However, no method of transmission over the internet or electronic storage is 100% secure.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 18.h),
              Text('5. Your Rights', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              _buildBullet(
                textTheme,
                'Access, update, or delete your personal information',
              ),
              _buildBullet(textTheme, 'Opt out of marketing communications'),
              _buildBullet(textTheme, 'Withdraw consent at any time'),
              SizedBox(height: 18.h),
              Text('6. Children’s Privacy', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(
                'Our app is not intended for children under 13. We do not knowingly collect data from children under 13.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 18.h),
              Text('7. Changes to This Policy', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(
                'We may update this Privacy Policy from time to time. We will notify you of any changes by updating the date at the top of this policy.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 18.h),
              Text('8. Contact Us', style: textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(
                'If you have any questions or concerns about this Privacy Policy, please contact us at support@organicplants.app.',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 24.h),
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
