import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Widget? content;
  final double? height;
  final double? width;
  final Color? background;
  final Color? fontColor;
  final Widget? prefix;
  final Widget? suffix;
  final FontWeight fontWeight;
  final double fontSize;

  const ButtonWidget({
    required this.onPressed,
    this.title = '',
    this.height = 50,
    this.width,
    this.content,
    this.background = AppColors.blue,
    this.fontColor = AppColors.white,
    this.prefix,
    this.suffix,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w700,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      child: Material(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height! / 2),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            side: const BorderSide(color: AppColors.border, width: 1.5),
          ),
          child:
              content ??
              Row(
                mainAxisAlignment: prefix != null || suffix != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (prefix != null || suffix != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SizedBox(height: 25, width: 25, child: prefix),
                    ),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      color: fontColor,
                      fontWeight: fontWeight,
                      fontSize: fontSize,
                    ),
                  ),
                  if (prefix != null || suffix != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(height: 25, width: 25, child: suffix),
                    ),
                  ],
                ],
              ),
        ),
      ),
    );
  }
}
