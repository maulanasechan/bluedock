import 'package:bluedock/common/helper/color/string_to_color_helper.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/notifications/domain/entities/notification_entity.dart';
import 'package:bluedock/features/notifications/domain/usecases/read_notif_usecase.dart';
import 'package:bluedock/features/notifications/presentation/bloc/notif_display_cubit.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotifEntity notif;
  const NotificationCardWidget({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return GestureDetector(
      onTap: () async {
        final res = await sl<ReadNotifUseCase>().call(
          params: notif.notificationId,
        );

        if (!context.mounted) return;

        if (res.isRight()) {
          await context.pushNamed(notif.route, extra: notif.params);

          if (context.mounted) {
            context.read<NotifDisplayCubit>().displayInitial();
          }
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
        decoration: BoxDecoration(
          color: parseHexColor(notif.type.color),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: AppColors.boxShadow,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(left: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),

          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: DateFormat(
                        'EE, dd MMM yyyy',
                      ).format(notif.createdAt.toDate()),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    if (notif.readerIds.contains(uid) == false)
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Material(
                          shape: const CircleBorder(
                            side: BorderSide(color: AppColors.border, width: 1),
                          ),
                          elevation: 4,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 26,
                        height: 26,
                        child: Image.asset(
                          notif.type.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 8),
                      TextWidget(
                        text: notif.type.title,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: parseHexColor(notif.type.color),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextWidget(
                    text: notif.title,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    overflow: TextOverflow.fade,
                    align: TextAlign.justify,
                  ),
                  SizedBox(height: 10),
                  TextWidget(
                    text: notif.subTitle,
                    fontSize: 14,
                    overflow: TextOverflow.fade,
                    align: TextAlign.justify,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
