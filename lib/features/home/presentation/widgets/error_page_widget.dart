import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPageWidget extends StatelessWidget {
  final String image;
  final double height;
  final String title;
  final String subtitle;
  const ErrorPageWidget({
    super.key,
    required this.image,
    this.height = 214,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text: 'Oops!',
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
            SizedBox(height: 32),
            SizedBox(
              height: height,
              child: Image.asset(image, fit: BoxFit.fitHeight),
            ),
            SizedBox(height: 28),
            TextWidget(text: title, fontWeight: FontWeight.w700, fontSize: 24),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextWidget(
                text: subtitle,
                align: TextAlign.center,
                overflow: TextOverflow.fade,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 45),
            ButtonWidget(
              width: 200,
              onPressed: () {
                context.goNamed(AppRoutes.home);
              },
              fontSize: 16,
              title: 'Return to Home',
            ),
          ],
        ),
      ),
    );
  }
}
