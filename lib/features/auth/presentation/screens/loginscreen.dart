import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/app_theme.dart';
import 'package:organicplants/features/auth/logic/auth_service.dart';
import 'package:organicplants/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:organicplants/features/auth/presentation/screens/signup_screen.dart';
import 'package:organicplants/shared/buttons/submit_custom_buttons.dart';
import 'package:organicplants/shared/widgets/custom_textfield.dart';
import 'package:organicplants/features/entry/presentation/screen/entry_screen.dart';
import 'package:organicplants/shared/widgets/gesture_detector_button.dart';
import 'package:organicplants/shared/widgets/custom_dialog.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});
  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Add ValueNotifier for loading state
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _isGoogleLoading = ValueNotifier(false);

  //logi with user email and password

  // final auth = FirebaseAuth.instance;
  // final countryCode = "+91";

  // Add ValueNotifier for state management
  // final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  // final ValueNotifier<bool> _isPhoneValid = ValueNotifier(false);
  // final ValueNotifier<String> _errorMessage = ValueNotifier('');

  @override
  void dispose() {
    _isLoading.dispose();
    _isGoogleLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    //login with google account

    // void login() {
    //   if (!_isPhoneValid.value) {
    //     _errorMessage.value = "Please enter a valid 10-digit phone number";
    //     return;
    //   }

    //   _isLoading.value = true;
    //   _errorMessage.value = '';

    //   auth.verifyPhoneNumber(
    //     phoneNumber: "+91${number.text}",
    //     verificationCompleted: (_) {
    //       _isLoading.value = false;
    //       CustomSnackBar.showSuccess(context, "Verification Completed! 🎉");
    //     },
    //     verificationFailed: (e) {
    //       _isLoading.value = false;
    //       _errorMessage.value = "Verification Failed: ${e.message}";
    //       CustomSnackBar.showError(context, "Verification Failed! ❌");
    //     },
    //     codeSent: (String verificationId, int? resendToken) {
    //       _isLoading.value = false;
    //       CustomSnackBar.showSuccess(context, 'OTP sent successfully');

    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder:
    //               (context) => OTPscreen(
    //                 verificationId: verificationId,
    //                 text: number.text,
    //               ),
    //         ),
    //       );
    //     },
    //     codeAutoRetrievalTimeout: (e) {
    //       _isLoading.value = false;
    //       _errorMessage.value = "Code Auto Retrieval Timeout!";
    //       // CustomSnackBar.showError(context, "Code Auto Retrieval Timeout! ❌");
    //     },
    //   );
    // }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return await CustomDialog.showConfirmation(
              context: context,
              title: "Are you sure?",
              content: "Do you want to exit the app?",
              confirmText: "Yes, Exit",
              cancelText: "No, Stay",
              icon: Icons.exit_to_app_outlined,
              iconColor: Theme.of(context).colorScheme.error,
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: AppSizes.paddingSm),
              child: GestureDetectorButton(
                textColor: AppTheme.primaryColor,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => EntryScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // TOP HEADER
            Padding(
              padding: EdgeInsets.only(
                left: AppSizes.paddingMd,
                bottom: AppSizes.paddingSm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Welcome Back \n",
                      style: textTheme.displayLarge,
                      children: [
                        TextSpan(
                          text: "Login in to continue",
                          style: textTheme.displayMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        'https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080572/ltree_hyjza1.png',
                    width: 0.3.sw,
                    height: 0.2.sh,
                    cacheManager: MyCustomCacheManager.instance,
                  ),
                ],
              ),
            ),
            // BOTTOM CONTENT
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
                        //password field
                        CustomTextField(
                          hintText: 'Password',
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: Icons.visibility_off_outlined,
                          obsecureText: true,
                        ),
                        SizedBox(height: 6.h),
                        //forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?    ',
                              style: textTheme.labelLarge?.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        //divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 3,
                                indent: 15,
                                endIndent: 10,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                              ),
                              child: Text(
                                'Or',
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 3,
                                indent: 10,
                                endIndent: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        //coninue with google account sign in
                        ValueListenableBuilder<bool>(
                          valueListenable: _isGoogleLoading,
                          builder: (context, isLoading, child) {
                            return SubmitCustomButtons(
                              width: 323.w,
                              ontap: () async {
                                _isGoogleLoading.value = true;
                                await AuthService.signInWithGoogle(context);
                                _isGoogleLoading.value = false;
                              },
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              text: 'Continue with Google',
                              networkImage:
                                  "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753412480/google_gy8mpr.png",
                              textColor: colorScheme.onSurface,
                              isBorder: true,
                              isLoading: isLoading,
                              //icon: Icons.google,
                            );
                          },
                        ),
                        SizedBox(height: 110.h),
                        //login button
                        ValueListenableBuilder<bool>(
                          valueListenable: _isLoading,
                          builder: (context, isLoading, child) {
                            return SubmitCustomButtons(
                              width: 323.w,
                              ontap: () async {
                                if (formKey.currentState!.validate()) {
                                  _isLoading.value = true;
                                  await AuthService.loginWithEmailAndPassword(
                                    context,
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                                  _isLoading.value = false;
                                }
                              },
                              backgroundColor: colorScheme.primary,
                              text: 'LogIn',
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
                              text: "Don't have an account? ",
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
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
                                                      const SignupScreen(),
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
      ),
    );
  }
}
