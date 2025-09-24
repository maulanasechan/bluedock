import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DropdownWidget extends StatelessWidget {
  final String? title;
  const DropdownWidget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          TextWidget(text: title!, fontSize: 16, fontWeight: FontWeight.w500),
        if (title != null) SizedBox(height: 12),
        GestureDetector(
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(width: 1.5, color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Role',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  PhosphorIcon(
                    PhosphorIconsBold.caretDown,
                    size: 24,
                    color: AppColors.blue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
