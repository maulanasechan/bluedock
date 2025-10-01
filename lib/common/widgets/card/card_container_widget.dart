import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CardContainerWidget extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  const CardContainerWidget({
    super.key,
    this.child,
    this.height,
    this.width,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.fromLTRB(0, 0, 0, 6),
        width: width ?? double.maxFinite,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border, width: 1.5),
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
        child: child,
      ),
    );
  }
}
