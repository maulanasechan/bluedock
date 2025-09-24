import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/features/home/presentation/widgets/error_page_widget.dart';
import 'package:flutter/material.dart';

class PageNotFoundPage extends StatelessWidget {
  const PageNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorPageWidget(
      image: AppImages.appPageNotFound,
      title: 'Page Not Found',
      subtitle: 'We are sorry, the page you are looking for is not available.',
    );
  }
}
