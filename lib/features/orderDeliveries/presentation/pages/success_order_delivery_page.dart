import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/success/success_page_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessOrderDeliveryPage extends StatelessWidget {
  final String title;
  final String? image;
  const SuccessOrderDeliveryPage({super.key, required this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      body: SuccessPageWidget(
        image: image == '' ? AppImages.appTaskCreated : image!,
        title: title,
        onPressed: () {
          context.pop(true);
        },
        buttonWidth: 230,
        titleButton: 'Return to Order Delivery',
      ),
    );
  }
}
