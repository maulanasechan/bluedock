import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationButtonWidget extends StatelessWidget {
  const NotificationButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButtonWidget(
          iconSize: 20,
          icon: PhosphorIconsFill.bellSimpleRinging,
          iconColor: AppColors.orange,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Material(
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.border, width: 1),
            ),
            elevation: 4,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
