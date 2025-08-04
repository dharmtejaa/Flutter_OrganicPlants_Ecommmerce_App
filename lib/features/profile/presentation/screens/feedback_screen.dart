// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/shared/widgets/custom_textfield.dart';
import 'package:organicplants/shared/buttons/custombutton.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:organicplants/features/profile/logic/feedback_provider.dart';
import 'package:organicplants/shared/logic/user_profile_provider.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeedbackContent();
  }
}

class _FeedbackContent extends StatefulWidget {
  @override
  State<_FeedbackContent> createState() => _FeedbackContentState();
}

class _FeedbackContentState extends State<_FeedbackContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Feedback', style: textTheme.headlineMedium)),
      body: Consumer2<FeedbackProvider, UserProfileProvider>(
        builder: (context, feedbackProvider, userProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: AppSizes.paddingAllSm,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withOpacity(
                          0.3,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: colorScheme.surface,
                            child:
                                userProvider
                                        .userProfile!
                                        .profileImageUrl
                                        .isNotEmpty
                                    ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            userProvider
                                                .userProfile!
                                                .profileImageUrl,
                                        cacheManager:
                                            MyCustomCacheManager.instance,
                                        height: 40.h,
                                        width: 40.w,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Container(
                                              height: 40.h,
                                              width: 40.w,
                                              color:
                                                  colorScheme
                                                      .surfaceContainerHighest,
                                              child: Icon(
                                                Icons.person,
                                                size: 40.r,
                                                color:
                                                    colorScheme
                                                        .onSurfaceVariant,
                                              ),
                                            ),
                                      ),
                                    )
                                    : Container(
                                      height: 40.h,
                                      width: 40.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            colorScheme.surfaceContainerHighest,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 40.r,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Submitting as:',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  userProvider.displayName,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Message Input
                    Text('Your Feedback Message', style: textTheme.titleLarge),
                    SizedBox(height: 8.h),
                    Text(
                      'Tell us what you think about our app, suggestions, or any issues you\'ve encountered.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    CustomTextField(
                      width: double.infinity,
                      controller: _messageController,
                      hintText:
                          'Share your thoughts, suggestions, or report issues...',
                      fillColor: colorScheme.surfaceContainerHighest,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                    ),

                    SizedBox(height: 24.h),

                    // Submit Button
                    Center(
                      child: CustomButton(
                        width: 200.w,
                        height: 40.h,
                        backgroundColor: colorScheme.primary,
                        ontap:
                            feedbackProvider.isSubmitting
                                ? null
                                : () async {
                                  if (_messageController.text.trim().isEmpty) {
                                    CustomSnackBar.showError(
                                      context,
                                      'Please enter your feedback message',
                                    );
                                    return;
                                  }

                                  final success = await feedbackProvider
                                      .submitFeedback(
                                        message: _messageController.text,
                                        userProfileProvider: userProvider,
                                      );

                                  if (success) {
                                    CustomSnackBar.showSuccess(
                                      context,
                                      'Thank you for your feedback!',
                                    );
                                    _messageController.clear();
                                  } else {
                                    CustomSnackBar.showError(
                                      context,
                                      feedbackProvider.lastError ??
                                          'Failed to submit feedback',
                                    );
                                  }
                                },
                        text:
                            feedbackProvider.isSubmitting
                                ? 'Submitting...'
                                : 'Submit Feedback',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
