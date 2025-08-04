// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/profile/presentation/widgets/profile_custom_icon.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  final List<Map<String, dynamic>> _supportOptions = [
    {
      'title': 'Live Chat',
      'subtitle': 'Chat with our support team',
      'icon': Icons.chat_bubble_outline,
      'color': Colors.blue,
      'action': 'Start Chat',
    },
    {
      'title': 'Email Support',
      'subtitle': 'Send us an email',
      'icon': Icons.email_outlined,
      'color': Colors.green,
      'action': 'Send Email',
    },
    {
      'title': 'Call Us',
      'subtitle': 'Speak with our team',
      'icon': Icons.phone_outlined,
      'color': Colors.orange,
      'action': 'Call Now',
    },
    {
      'title': 'WhatsApp',
      'subtitle': 'Message us on WhatsApp',
      'icon': Icons.chat_bubble_outline,
      'color': Colors.green,
      'action': 'Open WhatsApp',
    },
  ];

  final List<Map<String, dynamic>> _commonIssues = [
    {
      'title': 'Order Issues',
      'icon': Icons.shopping_bag_outlined,
      'color': Colors.blue,
    },
    {'title': 'Plant Care', 'icon': Icons.eco_outlined, 'color': Colors.green},
    {
      'title': 'Payment Problems',
      'icon': Icons.payment_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'Delivery Issues',
      'icon': Icons.local_shipping_outlined,
      'color': Colors.purple,
    },
    {
      'title': 'Returns & Refunds',
      'icon': Icons.assignment_return_outlined,
      'color': Colors.red,
    },
    {
      'title': 'Account Issues',
      'icon': Icons.account_circle_outlined,
      'color': Colors.indigo,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Support", style: textTheme.headlineMedium),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
            size: AppSizes.iconMd,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSizes.paddingAllSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: AppSizes.paddingAllSm,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 14, 172, 114),
                    Color.fromARGB(255, 21, 208, 140),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Column(
                children: [
                  Container(
                    padding: AppSizes.paddingAllSm,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimaryContainer.withValues(
                        alpha: 0.2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      size: AppSizes.iconLg,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "How can we help you?",
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Our support team is here to assist you 24/7",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Contact Options
            Text("Contact Options", style: textTheme.titleLarge),
            SizedBox(height: 16.h),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                //crossAxisSpacing: 12.w,
                //mainAxisSpacing: 12.h,
                childAspectRatio: 0.8,
              ),
              itemCount: _supportOptions.length,
              itemBuilder: (context, index) {
                return _buildContactOptionCard(_supportOptions[index]);
              },
            ),

            SizedBox(height: 32.h),

            // Common Issues
            Text("Common Issues", style: textTheme.titleLarge),
            SizedBox(height: 16.h),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                //crossAxisSpacing: 5.w,
                //mainAxisSpacing: 5.h,
                childAspectRatio: 1.1,
              ),
              itemCount: _commonIssues.length,
              itemBuilder: (context, index) {
                return _buildIssueCard(_commonIssues[index]);
              },
            ),

            SizedBox(height: 32.h),

            // Support Hours
            Container(
              width: double.infinity,
              padding: AppSizes.paddingAllSm,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: colorScheme.primary,
                        size: AppSizes.iconMd,
                      ),
                      SizedBox(width: 12.w),
                      Text("Support Hours", style: textTheme.titleLarge),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildSupportHourRow("Monday - Friday", "9:00 AM - 8:00 PM"),
                  _buildSupportHourRow("Saturday", "10:00 AM - 6:00 PM"),
                  _buildSupportHourRow("Sunday", "10:00 AM - 4:00 PM"),
                  SizedBox(height: 16.h),
                  Container(
                    padding: AppSizes.paddingAllSm,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colorScheme.onPrimaryContainer,
                          size: AppSizes.iconSm,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            "Emergency support available 24/7 for urgent plant care issues",
                            style: textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOptionCard(Map<String, dynamic> option) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 3,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: InkWell(
        onTap: () => _handleContactOption(option),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Padding(
          padding: AppSizes.paddingAllSm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileCustomIcon(
                icon: option['icon'],
                iconColor: option['color'],
              ),
              SizedBox(height: 12.h),
              Text(option['title'], style: textTheme.titleLarge),
              SizedBox(height: 4.h),
              Text(
                option['subtitle'],
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: option['color'],
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Text(
                  option['action'],
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueCard(Map<String, dynamic> issue) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: InkWell(
        onTap: () => _handleIssueTap(issue),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Padding(
          padding: AppSizes.paddingAllSm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileCustomIcon(icon: issue['icon'], iconColor: issue['color']),
              SizedBox(height: 12.h),
              Text(
                issue['title'],
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportHourRow(String day, String hours) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: textTheme.bodyMedium),
          Text(hours, style: textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _handleContactOption(Map<String, dynamic> option) {
    switch (option['title']) {
      case 'Live Chat':
        _startLiveChat();
        break;
      case 'Email Support':
        _sendEmail();
        break;
      case 'Call Us':
        _makeCall();
        break;
      case 'WhatsApp':
        _openWhatsApp();
        break;
    }
  }

  void _handleIssueTap(Map<String, dynamic> issue) {
    CustomSnackBar.showInfo(context, 'Opening ${issue['title']} help...');
  }

  void _startLiveChat() {
    CustomSnackBar.showInfo(context, 'Starting live chat...');
  }

  void _sendEmail() {
    CustomSnackBar.showInfo(context, 'Opening email app...');
  }

  void _makeCall() {
    CustomSnackBar.showInfo(context, 'Making call...');
  }

  void _openWhatsApp() {
    CustomSnackBar.showInfo(context, 'Opening WhatsApp...');
  }
}
