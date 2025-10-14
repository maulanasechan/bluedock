import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/notifications/domain/usecases/count_unread_usecase.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NotificationButtonWidget extends StatelessWidget {
  const NotificationButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Either>(
      future: sl<CountUnreadUseCase>().call(),
      builder: (context, snap) {
        int count = 0;
        if (snap.hasData) {
          count = snap.data!.fold((_) => 0, (n) => n);
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButtonWidget(
              onPressed: () => context.goNamed(AppRoutes.notification),
              iconSize: 20,
              icon: PhosphorIconsFill.bellSimpleRinging,
              iconColor: AppColors.orange,
            ),
            if (count > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Material(
                  shape: const CircleBorder(
                    side: BorderSide(color: AppColors.border, width: 1),
                  ),
                  elevation: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
