import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProductRichTextWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  const ProductRichTextWidget({
    super.key,
    required this.title,
    this.subtitle = 'Unit',
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        text: title,
        style: const TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w700,
          color: AppColors.orange,
          height: 1.0,
        ),
        children: [
          WidgetSpan(child: SizedBox(width: 4)),
          TextSpan(
            text: subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
