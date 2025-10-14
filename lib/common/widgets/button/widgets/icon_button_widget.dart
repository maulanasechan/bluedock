import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class IconButtonWidget extends StatelessWidget {
  final Color iconColor;
  final Color backgroundColor;
  final PhosphorFlatIconData icon;
  final double iconSize;
  final double width;
  final VoidCallback? onPressed;

  const IconButtonWidget({
    super.key,
    this.backgroundColor = AppColors.white,
    this.iconColor = AppColors.darkBlue,
    this.icon = PhosphorIconsBold.caretLeft,
    this.iconSize = 18,
    this.width = 40,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.border, width: 1.5),
      ),
      elevation: 4,
      child: SizedBox(
        width: width,
        height: width,
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
          ),
          icon: PhosphorIcon(icon, color: iconColor, size: iconSize),
          onPressed: onPressed ?? () => context.pop(),
        ),
      ),
    );
  }
}
