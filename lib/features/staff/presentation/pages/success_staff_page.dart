import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/success/success_page_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:flutter/material.dart';

class SuccessStaffPage extends StatelessWidget {
  final String title;
  const SuccessStaffPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      body: SuccessPageWidget(
        image: AppImages.appUserCreated,
        title: title,
        route: AppRoutes.home,
        titleButton: 'Return to Home',
      ),
    );
  }
}
