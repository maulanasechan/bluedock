import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/features/home/presentation/widgets/error_page_widget.dart';
import 'package:flutter/material.dart';

class YouAreOfflinePage extends StatelessWidget {
  const YouAreOfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorPageWidget(
      image: AppImages.appOffline,
      height: 200,
      title: 'You are Offline',
      subtitle: 'Please check your connection.',
    );
  }
}
