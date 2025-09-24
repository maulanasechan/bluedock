import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/features/home/presentation/widgets/error_page_widget.dart';
import 'package:flutter/material.dart';

class UnderConstructionPage extends StatelessWidget {
  const UnderConstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorPageWidget(
      image: AppImages.appUnderConstruction,
      title: 'Under Construction',
      height: 175,
      subtitle:
          'We are sorry, the page you are looking for is currently under construction.',
    );
  }
}
