import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/features/auth/logic/auth_service.dart';
import 'package:organicplants/features/entry/presentation/screen/entry_screen.dart';
import 'package:organicplants/shared/logic/user_profile_provider.dart';
import 'package:organicplants/shared/widgets/custom_dialog.dart';
import 'package:organicplants/shared/widgets/custom_textfield.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:organicplants/shared/widgets/gesture_detector_button.dart';
import 'package:provider/provider.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  late final UserProfileProvider userProfileProvider;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController = TextEditingController(
    text: userProfileProvider.displayName,
  );
  late final TextEditingController emailController = TextEditingController(
    text: userProfileProvider.userEmail,
  );
  // final _phoneController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProfileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
  }
  // final _dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with current user data
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    // _phoneController.dispose();
    // _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Information", style: textTheme.headlineMedium),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
            size: AppSizes.iconMd,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          GestureDetectorButton(
            onPressed: () {
              userProfileProvider.updateUserProfile(
                email: emailController.text.trim(),
                fullName: nameController.text.trim(),
                profileImageUrl: userProfileProvider.profileImageUrl,
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EntryScreen()),
              );
            },
            text: "Save",
            textColor: colorScheme.primary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSizes.paddingAllMd,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: colorScheme.surface,
                      child:
                          userProfileProvider
                                  .userProfile!
                                  .profileImageUrl
                                  .isNotEmpty
                              ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      userProfileProvider
                                          .userProfile!
                                          .profileImageUrl,
                                  cacheManager: MyCustomCacheManager.instance,
                                  height: 110.h,
                                  width: 110.w,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Container(
                                        height: 110.h,
                                        width: 110.w,
                                        color:
                                            colorScheme.surfaceContainerHighest,
                                        child: Icon(
                                          Icons.person,
                                          size: 50.r,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                ),
                              )
                              : Container(
                                height: 110.h,
                                width: 110.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.surfaceContainerHighest,
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 50.r,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                    ),
                    SizedBox(height: 16.h),
                    TextButton.icon(
                      onPressed: _changeProfilePicture,
                      icon: Icon(Icons.camera_alt, color: colorScheme.primary),
                      label: Text(
                        "Change Photo",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              // Form Fields
              CustomTextField(
                controller: nameController,
                hintText: "Full Name",
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.name,
                fillColor: colorScheme.surface,
              ),
              SizedBox(height: 16.h),
              // Email Field
              CustomTextField(
                hintText: "Email",
                controller: emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                fillColor: colorScheme.surface,
                enabled: false,
              ),
              SizedBox(height: 170.h),
              // Delete Account Section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Danger Zone",
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Once you delete your account, there is no going back. Please be certain.",
                      style: textTheme.bodyMedium,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () async {
                        // Check if user signed in with Google or email/password
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          CustomSnackBar.showError(
                            context,
                            "No user is currently signed in.",
                          );
                          return;
                        }

                        final isGoogleUser = user.providerData.any(
                          (profile) => profile.providerId == 'google.com',
                        );
                        final isEmailUser = user.providerData.any(
                          (profile) => profile.providerId == 'password',
                        );

                        if (isGoogleUser) {
                          // For Google users, just show confirmation dialog
                          AuthService.deleteAccount(context);
                        } else if (isEmailUser) {
                          // For email/password users, show password input dialog
                          final passwordController = TextEditingController();
                          CustomDialog.showCustom(
                            context: context,
                            title: "Re-authenticate to Delete",
                            content: CustomTextField(
                              hintText: "Enter your password",
                              controller: passwordController,
                              obsecureText: true,
                            ),
                            confirmText: "Delete",
                            isDestructive: true,
                            onConfirm: () {
                              if (passwordController.text.isNotEmpty) {
                                AuthService.deleteAccount(
                                  context,
                                  password: passwordController.text,
                                );
                              } else {
                                CustomSnackBar.showError(
                                  context,
                                  "Password cannot be empty",
                                );
                              }
                            },
                          );
                        } else {
                          CustomSnackBar.showError(
                            context,
                            "Unknown authentication method.",
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                      ),
                      child: Text(
                        "Delete Account",
                        style: textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildDropdownField({
  //   required String label,
  //   required String value,
  //   required List<String> items,
  //   Color? fillColor,
  //   required Function(String?) onChanged,
  // }) {
  //   final colorScheme = Theme.of(context).colorScheme;
  //   final textTheme = Theme.of(context).textTheme;
  //   return DropdownButtonFormField<String>(
  //     value: value,
  //     style: textTheme.bodyMedium,
  //     decoration: InputDecoration(
  //       fillColor:
  //           (fillColor ??
  //               (colorScheme.brightness == Brightness.dark
  //                   ? DarkThemeColors.darkCharcoal
  //                   : LightThemeColors.pureWhite)),
  //       labelText: label,

  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusLg)),
  //         borderSide: BorderSide(color: colorScheme.surface),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusLg)),
  //         borderSide: BorderSide(color: colorScheme.primary),
  //       ),
  //     ),
  //     items:
  //         items.map((String item) {
  //           return DropdownMenuItem<String>(value: item, child: Text(item));
  //         }).toList(),
  //     onChanged: onChanged,
  //   );
  // }

  void _changeProfilePicture() {
    CustomSnackBar.showInfo(
      context,
      "Profile picture change feature coming soon!",
      duration: Duration(seconds: 2),
    );
  }
}
