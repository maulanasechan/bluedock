import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/features/home/presentation/widgets/error_page_widget.dart';
import 'package:flutter/material.dart';

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorPageWidget(
      image: AppImages.appAccessDenied,
      height: 204,
      title: 'Access Denied',
      subtitle: 'We are sorry, you don’t have access to this page.',
    );
  }
}
