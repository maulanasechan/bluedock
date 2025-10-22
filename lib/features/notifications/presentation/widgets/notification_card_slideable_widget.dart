import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/notifications/domain/entities/notification_entity.dart';
import 'package:bluedock/features/notifications/domain/usecases/delete_notif_usecase.dart';
import 'package:bluedock/features/notifications/presentation/bloc/notif_display_cubit.dart';
import 'package:bluedock/features/notifications/presentation/widgets/notification_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationCardSlideableWidget extends StatelessWidget {
  final NotifEntity notif;
  const NotificationCardSlideableWidget({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        isDeleted: true,
        isUpdated: false,
        extentRatio: 0.2,
        onUpdateTap: () {},
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove Notification',
            subtitle: "Are you sure to remove this notification?",
            yesButton: 'Remove',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              actionCubit.execute(
                usecase: DeleteNotifUseCase(),
                params: notif.notificationId,
              );
              final ok = await waitActionDone(actionCubit);
              if (ok && context.mounted) context.pop(true);
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.notifSucces,
              extra: 'Notification has been removed',
            );
            if (change == true && context.mounted) {
              context.read<NotifDisplayCubit>().displayInitial();
            }
          }
        },
        deleteParams: notif.notificationId,
        child: NotificationCardWidget(notif: notif),
      ),
    );
  }
}
