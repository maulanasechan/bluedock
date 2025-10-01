import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/success/success_page_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:flutter/material.dart';

class SuccessProductPage extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const SuccessProductPage({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      body: SuccessPageWidget(
        image: AppImages.appAddedProduct,
        title: title,
        onPressed: onPressed,
        titleButton: 'Return to Product Page',
      ),
    );
  }
}
