import 'package:bluedock/common/helper/dateTime/format_time_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/dailyTask/domain/entities/daily_task_entity.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/delete_daily_task_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DailyTaskDetailPage extends StatelessWidget {
  final DailyTaskEntity task;
  const DailyTaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ActionButtonCubit())],
      child: GradientScaffoldWidget(
        hideBack: false,
        body: Column(
          children: [
            _contentWidget(context),
            SizedBox(height: 50),
            userEmail == task.createdBy
                ? _bottomNavWidget(context, task)
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _contentWidget(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: task.title,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            SizedBox(height: 4),
            TextWidget(
              text: task.description,
              fontSize: 16,
              overflow: TextOverflow.fade,
              align: TextAlign.justify,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                      child: TextWidget(
                        text: 'Date',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    TextWidget(
                      text: DateFormat(
                        'dd MMM yyyy',
                      ).format(task.date!.toDate()),
                      fontSize: 16,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                      child: TextWidget(
                        text: 'Start',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    TextWidget(
                      text: formatOnlyTime(context, task.startTime),
                      fontSize: 16,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                      child: TextWidget(
                        text: 'End',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    TextWidget(
                      text: formatOnlyTime(context, task.endTime),
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.projectName != '')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                        child: TextWidget(
                          text: 'Project Name',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    if (task.projectName != '')
                      TextWidget(text: task.projectName, fontSize: 16),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.projectName != '')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                        child: TextWidget(
                          text: 'Company Name',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    if (task.projectName != '')
                      TextWidget(text: task.customerCompany, fontSize: 16),
                  ],
                ),
              ],
            ),

            if (task.projectCategory != '')
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                child: TextWidget(
                  text: 'Project',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            if (task.projectCategory != '')
              TextWidget(
                text: '${task.projectCategory} - ${task.projectModel}',
                fontSize: 16,
              ),

            if (task.projectDescription != '')
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                child: TextWidget(
                  text: 'Project Description',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            if (task.projectDescription != '')
              TextWidget(text: task.projectDescription, fontSize: 16),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
              child: TextWidget(
                text: 'Staff Invited',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: task.listParticipant.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextWidget(
                    text: s.fullName,
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
              child: TextWidget(
                text: 'Created By',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            TextWidget(text: task.createdBy, fontSize: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                      child: TextWidget(
                        text: 'Created At',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    TextWidget(
                      text: DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(task.createdAt.toDate()),
                      fontSize: 16,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.updatedAt != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                        child: TextWidget(
                          text: 'Updated At',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    if (task.updatedAt != null)
                      TextWidget(
                        text: DateFormat(
                          'dd MMM yyyy, HH:mm',
                        ).format(task.updatedAt!.toDate()),
                        fontSize: 16,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavWidget(BuildContext context, DailyTaskEntity task) {
    return Builder(
      builder: (context) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ButtonWidget(
                  onPressed: () async {
                    final changed = await context.pushNamed(
                      AppRoutes.formDailyTask,
                      extra: task,
                    );
                    if (changed == true && context.mounted) {
                      context.pop(true);
                    }
                  },
                  background: AppColors.orange,
                  title: 'Update Daily Task',
                  fontSize: 16,
                ),
                SizedBox(height: 16),
                ButtonWidget(
                  onPressed: () async {
                    final actionCubit = context.read<ActionButtonCubit>();
                    final changed = await CenterModalWidget.display(
                      context: context,
                      title: 'Remove Task',
                      subtitle: "Are you sure to remove ${task.title}?",
                      yesButton: 'Remove',
                      actionCubit: actionCubit,
                      yesButtonOnTap: () {
                        context.read<ActionButtonCubit>().execute(
                          usecase: DeleteDailyTaskUseCase(),
                          params: task.dailyTaskId,
                        );
                        context.pop(true);
                      },
                    );
                    if (changed == true && context.mounted) {
                      final change = await context.pushNamed(
                        AppRoutes.successStaff,
                        extra: {
                          'title': '${task.title} has been removed',
                          'image': AppImages.appUserDeleted,
                        },
                      );

                      if (change == true && context.mounted) {
                        context.pop(true);
                      }
                    }
                  },
                  background: AppColors.red,
                  title: 'Delete Task',
                  fontSize: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
