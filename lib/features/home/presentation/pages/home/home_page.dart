import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/features/home/data/sources/menu_service.dart';
import 'package:bluedock/features/home/presentation/widgets/home_avatar_widget.dart';
import 'package:bluedock/features/home/presentation/widgets/menu_list_widget.dart';
import 'package:bluedock/features/home/presentation/widgets/notification_button_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      hideBack: true,
      body: Column(
        children: [
          SizedBox(height: 90),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [HomeAvatarWidget(), NotificationButtonWidget()],
          ),
          SizedBox(height: 50),
          Expanded(child: MenuListWidget(listMenu: listMenu)),
        ],
      ),
    );
  }
}
