import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/dark_theme_colors.dart';
import 'package:organicplants/core/theme/light_theme_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final bool obsecureText;
  final IconData? prefixIcon;
  final dynamic suffixIcon; // IconData or Widget
  final bool? readOnly;
  final TextEditingController controller;
  final TextEditingController? confirmPasswordController;
  final VoidCallback? onTap;
  final Color? fillColor;
  final EdgeInsets? contentPadding;
  final int? maxLines;
  final int? maxLength;
  final double? width;
  final ValueNotifier<bool>? isObscureNotifier; // 🔁 ValueNotifier
  final bool? enabled;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.keyboardType,
    this.obsecureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.maxLines,
    this.width,
    this.fillColor,
    this.contentPadding,
    required this.controller,
    this.confirmPasswordController,
    this.isObscureNotifier, // 👈 pass this for obscure toggle
    this.enabled = true,
  });

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty!';
    }

    final hint = hintText.toLowerCase();

    if (hint == "email") {
      if (!RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      ).hasMatch(value)) {
        return 'Enter a valid email!';
      }
    } else if (hint == "password" ||
        hint == "new password" ||
        hint == "confirm password") {
      if (value.length < 8) return 'Password must be at least 8 characters!';
      if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
        return 'Password must contain at least one uppercase letter!';
      }
      if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
        return 'Password must contain at least one number!';
      }
      if (!RegExp(r'(?=.*[!@#$%^&*])').hasMatch(value)) {
        return 'Password must contain at least one special character!';
      }
    } else if (hint == "number") {
      if (!RegExp(r"^\d{10,}$").hasMatch(value)) {
        return 'Enter a valid phone number!';
      }
    } else if (hint == "name") {
      if (value.length < 3) return 'Name must be at least 3 characters!';
      if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
        return 'Name must contain only letters!';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final notifier = isObscureNotifier ?? ValueNotifier<bool>(obsecureText);

    return SizedBox(
      width: width ?? 0.87.sw,
      child: ValueListenableBuilder<bool>(
        valueListenable: notifier,
        builder: (_, isObscure, __) {
          return TextFormField(
            enabled: enabled ?? true,
            controller: controller,
            obscureText: isObscure,
            keyboardType: keyboardType,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),

            validator: _validateInput,
            //readOnly: readOnly ?? false,
            maxLength: maxLength ?? 50,
            maxLines: maxLines ?? 1,

            decoration: InputDecoration(
              hintText: hintText,
              counterText: '',

              hintStyle: textTheme.bodyLarge?.copyWith(
                // ignore: deprecated_member_use
                color: colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
              contentPadding:
                  contentPadding ?? EdgeInsets.all(AppSizes.paddingMd),
              prefixIcon:
                  prefixIcon != null
                      ? Icon(prefixIcon, size: AppSizes.iconSm)
                      : null,
              suffixIcon:
                  obsecureText
                      ? GestureDetector(
                        onTap: () => notifier.value = !notifier.value,
                        child: Icon(
                          isObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      )
                      : (suffixIcon != null
                          ? (suffixIcon is Widget
                              ? suffixIcon
                              : Icon(suffixIcon, size: AppSizes.iconSm))
                          : null),
              filled: true,
              fillColor:
                  (fillColor ??
                      (colorScheme.brightness == Brightness.dark
                          ? DarkThemeColors.richBlack
                          : LightThemeColors.mediumGray)),

              suffixIconColor: colorScheme.onSurface,
              prefixIconColor: colorScheme.onSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.radiusLg),
                ),
                borderSide: BorderSide(color: colorScheme.surface),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.radiusLg),
                ),
                borderSide: BorderSide(color: colorScheme.surface),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.radiusLg),
                ),
                borderSide: BorderSide(color: colorScheme.primary),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.radiusLg),
                ),
                borderSide: BorderSide(color: colorScheme.error),
              ),
            ),
          );
        },
      ),
    );
  }
}
