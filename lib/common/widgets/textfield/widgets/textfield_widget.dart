import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/common/widgets/textfield/widgets/custom_textfield_widget.dart';
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
  final double borderRadius;
  final Color? iconColor;

  const TextfieldWidget({
    super.key,
    this.validator,
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
    this.borderRadius = 10,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      initialValue: initialValue,
      builder: (field) {
        final hasError = field.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title == null
                ? SizedBox()
                : TextWidget(
                    text: title!,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
            SizedBox(height: title == null ? 0 : 12),
            CustomTextfieldWidget(
              initialValue: initialValue,
              controller: controller,
              obscure: obscure,
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              suffixOnTap: suffixOnTap,
              maxLines: maxLines,
              borderRadius: borderRadius,
              iconColor: iconColor,
              hasError: hasError,
              onChanged: (value) {
                field.didChange(value);
                if (onChanged != null) onChanged!(value);
              },
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
