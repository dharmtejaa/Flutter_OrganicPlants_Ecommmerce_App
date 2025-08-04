// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/theme/app_theme.dart';
import 'package:organicplants/features/auth/logic/auth_service.dart';
import 'package:organicplants/features/auth/presentation/screens/loginscreen.dart';
import 'package:organicplants/shared/buttons/submit_custom_buttons.dart';
import 'package:organicplants/shared/widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Add ValueNotifier for loading state
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: AppSizes.paddingMd,
              bottom: AppSizes.paddingSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot Password?",
                    style: textTheme.displayLarge,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Don't worry! We'll send you a secure link\nto reset your password",
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: AppSizes.paddingSymmetricMd,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusXxl),
                  topRight: Radius.circular(AppSizes.radiusXxl),
                ),
                color: colorScheme.surface,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 10.h),
                      //email field
                      CustomTextField(
                        hintText: 'Email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(height: 16.h),
                      // //coninue with google sign in
                      // SubmitCustomButtons(
                      //   width: 323.w,
                      //   ontap: () async {
                      //     await AuthService.signInWithGoogle(context);
                      //   },
                      //   backgroundColor: colorScheme.surfaceContainerHighest,
                      //   text: 'Continue with Google',
                      //   networkImage:
                      //       "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753412480/google_gy8mpr.png",
                      //   textColor: colorScheme.onSurface,
                      //   isBorder: true,
                      //   //icon: Icons.google,
                      // ),
                      SizedBox(height: 380.h),
                      //reset password button
                      ValueListenableBuilder<bool>(
                        valueListenable: _isLoading,
                        builder: (context, isLoading, child) {
                          return SubmitCustomButtons(
                            width: 323.w,
                            ontap: () async {
                              if (formKey.currentState!.validate()) {
                                _isLoading.value = true;
                                await AuthService.resetPassword(
                                  context,
                                  emailController.text.trim(),
                                );
                                _isLoading.value = false;
                              }
                            },
                            backgroundColor: colorScheme.primary,
                            text: 'Reset Password',
                            isLoading: isLoading,
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingSm,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "Remember your password? ",
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: "LogIn",
                                style: textTheme.labelLarge?.copyWith(
                                  color: AppTheme.primaryColor,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    const Loginscreen(),
                                          ),
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
