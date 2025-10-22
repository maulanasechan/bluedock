import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';

class SuccessPageWidget extends StatelessWidget {
  final String image;
  final String title;
  final String titleButton;
  final double imageWidth;
  final Function() onPressed;
  final double buttonWidth;
  const SuccessPageWidget({
    super.key,
    required this.image,
    required this.title,
    required this.titleButton,
    this.imageWidth = 170,
    required this.onPressed,
    this.buttonWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: imageWidth,
            child: Image.asset(image, fit: BoxFit.fitWidth),
          ),
          SizedBox(height: 20),
          TextWidget(
            text: title,
            fontSize: 24,
            overflow: TextOverflow.fade,
            fontWeight: FontWeight.bold,
            align: TextAlign.center,
          ),
          SizedBox(height: 42),
          ButtonWidget(
            onPressed: onPressed,
            title: titleButton,
            fontSize: 16,
            width: buttonWidth,
          ),
        ],
      ),
    );
  }
}
