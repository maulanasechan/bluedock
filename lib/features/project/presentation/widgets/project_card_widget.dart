import 'package:bluedock/common/bloc/projectSection/project_display_cubit.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/features/project/domain/usecases/favorite_project_usecase.dart';
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

    return CardContainerWidget(
      onTap: () async {
        final changed = await context.pushNamed(
          AppRoutes.projectDetail,
          extra: {'id': project.projectId, 'isEdit': true},
        );
        if (changed == true && context.mounted) {
          context.read<ProjectDisplayCubit>().displayInitial();
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
                  cubit.displayInitial();
                }
              },
              child: PhosphorIcon(
                isFav ? PhosphorIconsFill.heart : PhosphorIconsBold.heart,
                color: AppColors.orange,
                size: 28,
              ),
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
                        SizedBox(height: 14),
                        SizedBox(
                          width: 155,
                          child: TitleSubtitleWidget(
                            title: 'Product',
                            subtitle:
                                '${project.productCategory.title} - ${project.productSelection.productModel}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
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
                        SizedBox(height: 14),
                        TextWidget(
                          text: 'Status',
                          fontSize: 12,
                          overflow: TextOverflow.fade,
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: project.status == 'Inactive'
                                ? AppColors.red
                                : project.status == 'Done'
                                ? AppColors.green
                                : project.status == 'Commisioning'
                                ? AppColors.blue
                                : AppColors.orange,
                          ),
                          child: TextWidget(
                            text: project.status,
                            fontSize: 12,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
