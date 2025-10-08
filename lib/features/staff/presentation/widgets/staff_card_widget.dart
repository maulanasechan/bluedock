import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/staff/domain/entities/staff_entity.dart';
import 'package:bluedock/features/staff/domain/usecases/delete_staff_usecase.dart';
import 'package:bluedock/features/staff/presentation/bloc/staff_display_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class StaffCardWidget extends StatelessWidget {
  final StaffEntity staff;
  const StaffCardWidget({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.addOrUpdateStaff,
            extra: staff,
          );
          if (changed == true && context.mounted) {
            context.read<StaffDisplayCubit>().displayStaff(params: '');
          }
        },
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove Staff',
            subtitle: "Are you sure to remove ${staff.fullName}?",
            yesButton: 'Remove',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              context.read<ActionButtonCubit>().execute(
                usecase: DeleteStaffUseCase(),
                params: staff.staffId,
              );
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.successStaff,
              extra: {
                'title': '${staff.fullName} has been removed',
                'image': AppImages.appUserDeleted,
              },
            );
            if (change == true && context.mounted) {
              context.read<StaffDisplayCubit>().displayStaff(params: '');
            }
          }
        },
        deleteParams: staff.staffId,
        child: CardContainerWidget(
          onTap: () async {
            final changed = await context.pushNamed(
              AppRoutes.staffDetail,
              extra: staff,
            );
            if (changed == true && context.mounted) {
              context.read<StaffDisplayCubit>().displayStaff(params: '');
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(staff.image),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: staff.fullName,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        if (staff.lastOnline != Timestamp(0, 0))
                          TextWidget(
                            text: 'Online',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextWidget(
                            text: staff.role.title,
                            fontSize: 12,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        TextWidget(
                          text: staff.lastOnline != Timestamp(0, 0)
                              ? timeago.format(staff.lastOnline.toDate())
                              : '',
                          fontSize: 12,
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
