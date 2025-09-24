import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessPageWidget extends StatelessWidget {
  final String image;
  final String title;
  final String route;
  final String titleButton;
  final double imageWidth;
  const SuccessPageWidget({
    super.key,
    required this.image,
    required this.title,
    required this.route,
    required this.titleButton,
    this.imageWidth = 170,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: TextWidget(
              text: title,
              fontSize: 24,
              overflow: TextOverflow.fade,
              fontWeight: FontWeight.bold,
              align: TextAlign.center,
            ),
          ),
          SizedBox(height: 42),
          ButtonWidget(
            onPressed: () {
              context.goNamed(route);
            },
            title: titleButton,
            fontSize: 16,
            width: 200,
          ),
        ],
      ),
    );
  }
}
