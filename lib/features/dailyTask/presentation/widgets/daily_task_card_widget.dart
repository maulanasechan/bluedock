import 'package:bluedock/common/helper/color/string_to_color_helper.dart';
import 'package:bluedock/common/helper/dateTime/format_time_helper.dart';
import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/dailyTask/domain/entities/daily_task_entity.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/delete_daily_task_usecase.dart';
import 'package:bluedock/features/dailyTask/presentation/bloc/calendar/calendar_cubit.dart';
import 'package:bluedock/features/dailyTask/presentation/bloc/dailyTask/daily_task_display_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DailyTaskCardWidget extends StatelessWidget {
  final DailyTaskEntity dailyTask;
  final int index;
  const DailyTaskCardWidget({
    super.key,
    required this.dailyTask,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: Padding(
        padding: EdgeInsets.only(top: index == 0 ? 24 : 0),
        child: userEmail == dailyTask.createdBy
            ? _slideableWidget(context)
            : _cardWidget(context),
      ),
    );
  }

  Widget _slideableWidget(BuildContext context) {
    return SlidableActionWidget(
      onUpdateTap: () async {
        final changed = await context.pushNamed(
          AppRoutes.formDailyTask,
          extra: dailyTask,
        );
        if (changed == true && context.mounted) {
          context.read<DailyTaskDisplayCubit>().displayDailyTask(
            params: DateTime.now(),
          );
          context.read<CalendarDisplayCubit>().onDaySelected(
            DateTime.now(),
            DateTime.now(),
          );
        }
      },
      onDeleteTap: () async {
        final actionCubit = context.read<ActionButtonCubit>();
        final changed = await CenterModalWidget.display(
          context: context,
          title: 'Remove Task',
          subtitle: "Are you sure to remove ${dailyTask.title}?",
          yesButton: 'Remove',
          actionCubit: actionCubit,
          yesButtonOnTap: () async {
            actionCubit.execute(
              usecase: DeleteDailyTaskUseCase(),
              params: dailyTask.dailyTaskId,
            );
            final ok = await waitActionDone(actionCubit);
            if (ok && context.mounted) context.pop(true);
          },
        );
        if (changed == true && context.mounted) {
          final change = await context.pushNamed(
            AppRoutes.successDaily,
            extra: {
              'title': '${dailyTask.title} has been removed',
              'image': AppImages.appTaskDeleted,
            },
          );
          if (change == true && context.mounted) {
            context.read<DailyTaskDisplayCubit>().displayDailyTask(
              params: DateTime.now(),
            );
            context.read<CalendarDisplayCubit>().onDaySelected(
              DateTime.now(),
              DateTime.now(),
            );
          }
        }
      },
      deleteParams: dailyTask.dailyTaskId,
      child: _cardWidget(context),
    );
  }

  Widget _cardWidget(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: formatOnlyTime(context, dailyTask.startTime),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(width: 18),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final changed = await context.pushNamed(
                AppRoutes.detailDailyTask,
                extra: dailyTask,
              );
              if (changed == true && context.mounted) {
                context.read<DailyTaskDisplayCubit>().displayDailyTask(
                  params: DateTime.now(),
                );
                context.read<CalendarDisplayCubit>().onDaySelected(
                  DateTime.now(),
                  DateTime.now(),
                );
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
              decoration: BoxDecoration(
                color: dailyTask.dailyTaskCategory.color == ''
                    ? AppColors.orange
                    : parseHexColor(dailyTask.dailyTaskCategory.color),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: dailyTask.title,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    if (dailyTask.projectName != '')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextWidget(
                          text:
                              '${dailyTask.projectName} - ${dailyTask.customerCompany}',
                          fontSize: 14,
                        ),
                      ),
                    if (dailyTask.description != '')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextWidget(
                          text: dailyTask.description,
                          fontSize: 14,
                        ),
                      ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            PhosphorIcon(PhosphorIconsRegular.calendarDots),
                            SizedBox(width: 10),
                            TextWidget(
                              text:
                                  '${formatOnlyTime(context, dailyTask.startTime)} - ',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            TextWidget(
                              text: formatOnlyTime(context, dailyTask.endTime),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                        if (dailyTask.dailyTaskCategory.image != '')
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  dailyTask.dailyTaskCategory.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: 10),
                              TextWidget(
                                text: dailyTask.dailyTaskCategory.title,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: parseHexColor(
                                  dailyTask.dailyTaskCategory.color,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
