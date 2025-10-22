import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/project/domain/usecases/commision_project_usecase.dart';
import 'package:bluedock/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_cubit.dart';
import 'package:bluedock/features/project/presentation/widgets/project_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProjectCardSlidableWidget extends StatelessWidget {
  final ProjectEntity project;
  const ProjectCardSlidableWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        extentRatio: project.blDate != null ? 0.2 : 0.4,
        isSlideable:
            userEmail == project.createdBy && project.status == 'Inactive'
            ? true
            : project.blDate != null && project.status != 'Done'
            ? true
            : false,

        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.formProject,
            extra: project,
          );
          if (changed == true && context.mounted) {
            context.read<ProjectDisplayCubit>().displayInitial();
          }
        },
        isUpdated: project.status == 'Inactive' && project.blDate == null,
        deleteColor: project.blDate != null
            ? project.status == 'Commissioning'
                  ? AppColors.green
                  : AppColors.blue
            : AppColors.orange,
        deleteText: project.status == 'Inactive'
            ? 'Delete'
            : project.status == 'Active'
            ? 'Start Commision'
            : 'Project Done',
        deleteIcon: project.status == 'Inactive'
            ? PhosphorIconsBold.trash
            : project.status == 'Active'
            ? PhosphorIconsFill.flagBannerFold
            : PhosphorIconsFill.checkCircle,
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            yesButtonColor: project.status == 'Inactive'
                ? AppColors.red
                : project.status == 'Active'
                ? AppColors.orange
                : AppColors.green,
            title: project.status == 'Inactive'
                ? 'Remove Project'
                : project.status == 'Active'
                ? 'Start Commision'
                : 'Project Done',
            subtitle: project.status == 'Inactive'
                ? "Are you sure to remove ${project.projectName}?"
                : project.status == 'Active'
                ? "Are you sure to start commisioning for this project ${project.projectName}?"
                : "Are you sure to make this project ${project.projectName} end?",
            yesButton: project.status == 'Inactive'
                ? 'Remove'
                : project.status == 'Active'
                ? 'Start'
                : 'Done',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              project.status == 'Inactive'
                  ? actionCubit.execute(
                      usecase: DeleteProjectUseCase(),
                      params: project,
                    )
                  : context.read<ActionButtonCubit>().execute(
                      usecase: CommisionProjectUseCase(),
                      params: project,
                    );
              final ok = await waitActionDone(actionCubit);
              if (ok && context.mounted) context.pop(true);
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.successProject,
              extra: {
                'title': project.status == 'Inactive'
                    ? '${project.projectName} has been removed'
                    : 'Start commisioning for ${project.projectName}',
                'image': project.status == 'Inactive'
                    ? AppImages.appProjectDeleted
                    : AppImages.appProjectSuccess,
              },
            );

            if (change == true && context.mounted) {
              context.read<ProjectDisplayCubit>().displayInitial();
            }
          }
        },
        deleteParams: project.projectId,
        child: ProjectCardWidget(project: project),
      ),
    );
  }
}
