import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BottomModalWidget {
  static Future<void> display(
    BuildContext context,
    Widget widget, {
    double? height,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Material(
          elevation: 4,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          child: Container(
            height: height ?? MediaQuery.of(context).size.height / 2.25,
            decoration: BoxDecoration(
              gradient: AppColors.gradientModal,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: widget,
          ),
        );
      },
    );
  }
}
