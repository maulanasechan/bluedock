import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RadioListButton extends StatelessWidget {
  final String title;
  final bool state;
  final VoidCallback onPressed;
  const RadioListButton({
    super.key,
    required this.title,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: title, fontSize: 16, fontWeight: FontWeight.w500),
        SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: state ? AppColors.blue : AppColors.white,
              ),
              padding: EdgeInsets.zero,
              onPressed: onPressed,
              icon: PhosphorIcon(
                PhosphorIconsBold.circle,
                color: state ? AppColors.white : AppColors.blue,
                size: 36,
              ),
            ),
            SizedBox(width: 6),
            TextWidget(
              text: 'Yes',
              fontSize: 16,
              fontWeight: state ? FontWeight.bold : FontWeight.w400,
            ),
            SizedBox(width: 30),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: state ? AppColors.white : AppColors.blue,
              ),
              padding: EdgeInsets.zero,
              onPressed: onPressed,
              icon: PhosphorIcon(
                PhosphorIconsBold.circle,
                color: state ? AppColors.blue : AppColors.white,
                size: 36,
              ),
            ),
            SizedBox(width: 6),
            TextWidget(
              text: 'No',
              fontSize: 16,
              fontWeight: state ? FontWeight.w400 : FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }
}
