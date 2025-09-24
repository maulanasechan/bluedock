import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TextfieldWidget extends StatelessWidget {
  final StringValidator? validator;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final String hintText;
  final TextEditingController? controller;
  final bool obscure;
  final PhosphorIconData? prefixIcon;
  final PhosphorIconData? suffixIcon;
  final GestureTapCallback? suffixOnTap;
  final String? title;
  final int? maxLines;

  const TextfieldWidget({
    super.key,
    required this.validator,
    this.onChanged,
    this.initialValue,
    this.controller,
    this.obscure = false,
    this.hintText = 'Password',
    this.prefixIcon,
    this.suffixIcon,
    this.suffixOnTap,
    this.title,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      builder: (field) {
        final hasError = field.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              TextWidget(
                text: title!,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            if (title != null) SizedBox(height: 12),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
              child: TextFormField(
                style: TextStyle(fontWeight: FontWeight.w500),
                initialValue: initialValue,
                maxLines: maxLines,
                onChanged: (value) {
                  field.didChange(value);
                  if (onChanged != null) onChanged!(value);
                },
                controller: controller,
                obscureText: obscure,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  error: null,
                  errorText: null,
                  errorStyle: TextStyle(height: 0, fontSize: 0),
                  hintText: hintText,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: hasError ? AppColors.blue : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  prefixIcon: prefixIcon != null
                      ? PhosphorIcon(
                          prefixIcon!,
                          size: 24,
                          color: AppColors.blue,
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
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                child: Text(
                  field.errorText!,
                  style: TextStyle(color: AppColors.blue, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
