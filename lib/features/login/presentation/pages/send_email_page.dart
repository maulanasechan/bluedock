import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/success/success_page_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SendEmailPage extends StatelessWidget {
  const SendEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      body: SuccessPageWidget(
        image: AppImages.appSendEmail,
        title: 'We sent you an email to reset your password.',
        onPressed: () {
          context.goNamed(AppRoutes.login);
        },
        titleButton: 'Return to Login',
      ),
    );
  }
}
