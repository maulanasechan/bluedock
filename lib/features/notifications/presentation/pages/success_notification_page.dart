import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/success/success_page_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessNotificationPage extends StatelessWidget {
  const SuccessNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      body: SuccessPageWidget(
        image: AppImages.appProjectSuccess,
        title: 'Notification has been removed',
        onPressed: () {
          context.pop(true);
        },
        titleButton: 'Return to Notification Page',
      ),
    );
  }
}
