import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomTextfieldWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final String hintText;
  final TextEditingController? controller;
  final bool obscure;
  final PhosphorIconData? prefixIcon;
  final PhosphorIconData? suffixIcon;
  final GestureTapCallback? suffixOnTap;
  final int? maxLines;
  final double borderRadius;
  final Color? iconColor;
  final bool hasError;

  const CustomTextfieldWidget({
    super.key,
    this.onChanged,
    this.initialValue,
    this.controller,
    this.obscure = false,
    this.hintText = 'Password',
    this.prefixIcon,
    this.suffixIcon,
    this.suffixOnTap,
    this.maxLines = 1,
    this.borderRadius = 10,
    this.iconColor,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          alignment: 0.1,
        );
      });
    }
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(borderRadius),
      color: Colors.transparent,
      child: TextFormField(
        style: TextStyle(fontWeight: FontWeight.w500),
        initialValue: initialValue,
        maxLines: maxLines,
        onChanged: onChanged,
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          error: null,
          errorText: null,
          errorStyle: TextStyle(height: 0, fontSize: 0),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: AppColors.blue, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: hasError ? AppColors.blue : AppColors.border,
              width: 1.5,
            ),
          ),
          prefixIcon: prefixIcon != null
              ? PhosphorIcon(
                  prefixIcon!,
                  size: 24,
                  color: iconColor ?? AppColors.blue,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: suffixOnTap ?? suffixOnTap,
                  child: PhosphorIcon(
                    suffixIcon!,
                    size: 24,
                    color: AppColors.blue,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
