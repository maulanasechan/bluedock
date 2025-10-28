import 'package:bluedock/common/helper/color/string_to_color_helper.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CardContainerWithTypeWidget extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final String typeColor;
  const CardContainerWithTypeWidget({
    super.key,
    this.child,
    this.height,
    this.width,
    this.onTap,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
        width: width ?? double.maxFinite,
        height: height,
        decoration: BoxDecoration(
          color: parseHexColor(typeColor),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: AppColors.boxShadow,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(left: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}
