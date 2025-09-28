import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DropdownWidget extends StatelessWidget {
  final String? title;
  final StringValidator? validator;
  final Widget? content;
  final double fontSize;
  final String state;
  final Function() onTap;

  const DropdownWidget({
    super.key,
    this.title,
    required this.validator,
    required this.onTap,
    required this.state,
    this.content,
    this.fontSize = 14,
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
            GestureDetector(
              onTap: onTap,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      width: 1.5,
                      color: hasError ? AppColors.blue : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: state,
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize,
                      ),
                      content != null
                          ? _contentWidget()
                          : PhosphorIcon(
                              PhosphorIconsBold.caretDown,
                              size: fontSize + 10,
                              color: AppColors.blue,
                            ),
                    ],
                  ),
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

  Widget _contentWidget() {
    return Row(
      children: [
        content!,
        const SizedBox(width: 30),
        PhosphorIcon(
          PhosphorIconsBold.caretDown,
          size: fontSize + 10,
          color: AppColors.blue,
        ),
      ],
    );
  }
}
