import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/presentation/widgets/product_rich_text_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:bluedock/features/project/domain/usecases/favorite_project_usecase.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_cubit.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProjectCardWidget extends StatelessWidget {
  final ProjectEntity project;
  const ProjectCardWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isFav = uid != null && project.favorites.contains(uid);

    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.formProject,
            extra: project,
          );
          if (changed == true && context.mounted) {
            context.read<ProjectDisplayCubit>().displayProject(params: '');
          }
        },
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove Product',
            subtitle: "Are you sure to remove ${project.projectName}?",
            yesButton: 'Remove',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              actionCubit.execute(
                usecase: DeleteProjectUseCase(),
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
                'title': '${project.projectName} has been removed',
                'image': AppImages.appProjectDeleted,
              },
            );
            if (change == true && context.mounted) {
              context.read<ProjectDisplayCubit>().displayProject(params: '');
            }
          }
        },
        deleteParams: project.projectId,
        child: CardContainerWidget(
          onTap: () async {
            final changed = await context.pushNamed(
              AppRoutes.projectDetail,
              extra: project,
            );
            if (changed == true && context.mounted) {
              context.read<ProjectDisplayCubit>().displayProject(params: '');
            }
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final cubit = context.read<ProjectDisplayCubit>();
                    final res = await sl<FavoriteProjectUseCase>().call(
                      params: project.projectId,
                    );

                    if (!context.mounted) return;

                    final changed = res.isRight();
                    if (changed) {
                      cubit.displayProject(params: '');
                    }
                  },
                  child: PhosphorIcon(
                    isFav ? PhosphorIconsFill.heart : PhosphorIconsBold.heart,
                    color: AppColors.orange,
                    size: 28,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ProductRichTextWidget(title: project.quantity.toString()),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 100,
                      child: Image.asset(
                        project.productSelection.image == ""
                            ? AppImages.appSperreScrewCompressor
                            : project.productSelection.image,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 155,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleSubtitleWidget(
                              title: 'Project Name',
                              subtitle: project.projectName,
                            ),
                            SizedBox(height: 14),
                            TitleSubtitleWidget(
                              title: 'Purchase Contract Number',
                              subtitle: project.purchaseContractNumber,
                            ),
                            SizedBox(height: 14),
                            TitleSubtitleWidget(
                              title: 'Custommer Company',
                              subtitle: project.customerCompany,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 32),
                      SizedBox(
                        width: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleSubtitleWidget(
                              title: 'Project Code',
                              subtitle: project.projectCode,
                            ),
                            SizedBox(height: 14),
                            TitleSubtitleWidget(
                              title: 'Custommer Name',
                              subtitle: project.customerName,
                            ),
                            SizedBox(height: 14),
                            TitleSubtitleWidget(
                              title: 'Custommer Contact',
                              subtitle: project.customerContact,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  SizedBox(
                    width: 230,
                    child: TitleSubtitleWidget(
                      title: 'Project Description',
                      subtitle: project.projectDescription,
                    ),
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
