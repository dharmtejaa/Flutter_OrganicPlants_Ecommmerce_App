// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
import 'package:organicplants/core/theme/appcolors.dart';
import 'package:organicplants/features/profile/presentation/widgets/profile_custom_icon.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("About Organic Plants", style: textTheme.headlineMedium),

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
            // Hero Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 14, 172, 114),
                    Color.fromARGB(255, 21, 208, 140),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(32.0),
                boxShadow: AppShadows.cardShadow(context),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimaryContainer.withValues(
                        alpha: 0.2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(10.w),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080823/app_logo_lxl2fw.png',
                      height: 48.h,
                      width: 48.h,
                      color: colorScheme.onPrimary,
                      colorBlendMode: BlendMode.srcIn,
                      cacheManager: MyCustomCacheManager.instance,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Organic Plants",
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Bringing Nature to Your Home",
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Version 1.0.0",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Our Story Section
            _buildSection(
              context,
              "Our Story",
              Icons.history_edu_rounded,
              "Organic Plants was founded with a simple\n\nmission: to make the joy of plant parenthood accessible to everyone. We believe that every home deserves the beauty and benefits that plants bring.\n\nOur journey began in 2025 when we noticed that many people wanted to bring plants into their homes but were intimidated by the complexity of plant care. We set out to change that by providing not just beautiful, healthy plants, but also the knowledge and support needed to help them thrive.",
            ),

            SizedBox(height: 16.h),

            // Our Mission Section
            _buildSection(
              context,
              "Our Mission",
              Icons.flag_outlined,
              "To inspire and empower people to create greener, healthier living spaces by providing premium plants, expert care guidance, and exceptional customer support.\n\nWe're committed to sustainability, quality, and making plant care accessible to everyone, from beginners to experienced gardeners.",
            ),

            SizedBox(height: 16.h),

            // What We Offer Section
            _buildFeaturesSection(context),

            SizedBox(height: 16.h),

            // Team Section
            _buildTeamSection(context),

            SizedBox(height: 16.h),

            // Contact Information
            _buildContactSection(context),

            SizedBox(height: 16.h),

            // Social Media Links
            _buildSocialMediaSection(context),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    String content,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: AppSizes.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: AppSizes.iconMd),
                SizedBox(width: 12.w),
                Text(title, style: textTheme.headlineMedium),
              ],
            ),
            SizedBox(height: 16.h),
            Text(content, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: AppSizes.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star_outline,
                  color: colorScheme.primary,
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: 12.w),
                Text("What We Offer", style: textTheme.headlineMedium),
              ],
            ),
            SizedBox(height: 16.h),
            _buildFeatureItem(
              context,
              "Premium Plants",
              "Carefully selected, healthy plants from trusted growers",
              Icons.local_florist_rounded,
              Colors.yellow,
            ),
            _buildFeatureItem(
              context,
              "Expert Care Guidance",
              "Detailed care instructions and plant care tips",
              Icons.menu_book_rounded,
              Colors.deepOrangeAccent,
            ),
            _buildFeatureItem(
              context,
              "Plant Care Support",
              "24/7 support from our plant care experts",
              Icons.support_agent_rounded,
              Colors.grey,
            ),
            _buildFeatureItem(
              context,
              "Sustainable Packaging",
              "Eco-friendly packaging to protect your plants",
              Icons.recycling_rounded,
              Colors.green,
            ),
            _buildFeatureItem(
              context,
              "Plant Guarantee",
              "30-day guarantee on all our plants",
              Icons.verified_rounded,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.paddingLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileCustomIcon(icon: icon, iconColor: color),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                ...[
                  SizedBox(height: AppSizes.spaceXs),
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: AppSizes.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  color: colorScheme.primary,
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: 12.w),
                Text("Our Team", style: textTheme.headlineMedium),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              "We're a passionate team of plant enthusiasts, horticulturists, and customer service experts dedicated to helping you succeed in your plant journey.\n\nOur team includes certified plant care specialists who are always ready to answer your questions and provide personalized advice.",
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: AppSizes.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_support_rounded,
                  color: colorScheme.primary,
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: 12.w),
                Text("Contact Us", style: textTheme.headlineMedium),
              ],
            ),
            SizedBox(height: 16.h),
            _buildContactItem(
              context,
              "Email",
              "support@organicplants.com",
              Icons.email_rounded,
              () => _launchEmail(context),
            ),
            _buildContactItem(
              context,
              "Phone",
              "+91 9876543210",
              Icons.phone_rounded,
              () => _launchPhone(context),
            ),
            _buildContactItem(
              context,
              "Address",
              "12-34-4, Marvel Nagaram, Pandora",
              Icons.location_on_rounded,
              () => _launchMaps(context),
            ),
            _buildContactItem(
              context,
              "Business Hours",
              "Monday - Sunday: 9:00 AM - 8:00 PM",
              Icons.access_time_rounded,
              null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    VoidCallback? onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: AppSizes.paddingAllSm,
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: AppSizes.iconMd),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.bodyMedium),
                    Text(
                      value,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: AppSizes.iconXs,
                  color: AppColors.mutedText,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: AppSizes.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.share_outlined,
                  color: colorScheme.primary,
                  size: AppSizes.iconMd,
                ),
                SizedBox(width: 12.w),
                Text("Follow Us", style: textTheme.headlineMedium),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialMediaButton(
                  "Instagram",
                  Icons.camera_alt_outlined,
                  Colors.redAccent,
                  () => _launchSocialMedia(context, "instagram"),
                ),
                _buildSocialMediaButton(
                  "Facebook",
                  Icons.facebook_outlined,
                  Colors.blue,
                  () => _launchSocialMedia(context, "facebook"),
                ),
                _buildSocialMediaButton(
                  "Twitter",
                  Icons.flutter_dash_outlined,
                  Colors.lightBlue,
                  () => _launchSocialMedia(context, "twitter"),
                ),
                _buildSocialMediaButton(
                  "YouTube",
                  Icons.play_circle_outline_outlined,
                  Colors.red,
                  () => _launchSocialMedia(context, "youtube"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: ProfileCustomIcon(icon: icon, iconColor: color),
    );
  }

  void _launchEmail(BuildContext context) {
    CustomSnackBar.showInfo(context, "Opening email app...");
  }

  void _launchPhone(BuildContext context) {
    CustomSnackBar.showInfo(context, "Opening phone app...");
  }

  void _launchMaps(BuildContext context) {
    CustomSnackBar.showInfo(context, "Opening maps app...");
  }

  void _launchSocialMedia(BuildContext context, String platform) {
    CustomSnackBar.showInfo(context, "Opening $platform...");
  }
}
