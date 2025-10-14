import 'package:bluedock/common/bloc/projectSection/project_display_cubit.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_state.dart';
import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/copy_button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:bluedock/features/project/presentation/widgets/project_text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;
  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (context) =>
              ProjectDisplayCubit()..displayProjectById(projectId),
        ),
      ],
      child: GradientScaffoldWidget(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
          child: BlocBuilder<ProjectDisplayCubit, ProjectDisplayState>(
            builder: (context, state) {
              if (state is ProjectDisplayLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is ProjectDisplayOneFetched) {
                final project = state.project;
                return Column(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButtonWidget(),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: _avatarWidget(project),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: project.status == 'Inactive'
                                    ? AppColors.red
                                    : project.status == 'Done'
                                    ? Colors.green
                                    : AppColors.orange,
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: project.status,
                                  fontSize: 16,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _contentWidget(project),
                            if (userEmail == project.createdBy)
                              _bottomNavWidget(context, project),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _avatarWidget(ProjectEntity project) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(
            project.productSelection.image == ''
                ? AppImages.appDetegasaIncenerator
                : project.productSelection.image,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 24),

        TextWidget(
          text: project.purchaseContractNumber,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _contentWidget(ProjectEntity project) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: SingleChildScrollView(
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
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Project Name',
                      subTitle: project.projectName,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Project Code',
                    subTitle: project.projectCode,
                  ),
                ],
              ),
              ProjectTextWidget(
                title: 'Customer Company',
                subTitle: project.customerCompany,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProjectTextWidget(
                    title: 'Customer Contact',
                    subTitle:
                        '${project.customerName} - ${project.customerContact}',
                  ),
                  CopyButtonWidget(text: project.customerContact),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Price',
                      subTitle:
                          '${project.currency} ${formatWithCommas(project.price.toString())}',
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Quantity',
                    subTitle: project.quantity.toString(),
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Categories',
                      subTitle: project.productCategory.title,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Product Model',
                    subTitle: project.productSelection.productModel,
                  ),
                ],
              ),
              ProjectTextWidget(
                title: 'Payment Type',
                subTitle: project.payment,
              ),
              ProjectTextWidget(
                title: 'Delivery Type',
                subTitle: project.delivery,
              ),
              ProjectTextWidget(
                title: 'Maintenance Period',
                subTitle:
                    'Every ${project.maintenancePeriod} ${project.maintenanceCurrency}',
              ),
              ProjectTextWidget(
                title: 'Project Description',
                subTitle: project.projectDescription == ''
                    ? '-'
                    : project.projectDescription,
              ),
              ProjectTextWidget(
                title: 'Warranty of Goods',
                subTitle: project.warrantyOfGoods,
              ),
              if (project.blDate != null)
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: ProjectTextWidget(
                        title: 'Bill of Ladding Date',
                        subTitle: DateFormat(
                          'dd MMM yyyy',
                        ).format(project.blDate!.toDate()),
                      ),
                    ),
                    ProjectTextWidget(
                      title: 'Warranty BL Date',
                      subTitle: DateFormat(
                        'dd MMM yyyy',
                      ).format(project.warrantyBlDate!.toDate()),
                    ),
                  ],
                ),
              if (project.commDate != null)
                Row(
                  children: [
                    SizedBox(
                      width: 155,
                      child: ProjectTextWidget(
                        title: 'Commisioning Date',
                        subTitle: DateFormat(
                          'dd MMM yyyy',
                        ).format(project.commDate!.toDate()),
                      ),
                    ),
                    SizedBox(width: 30),
                    ProjectTextWidget(
                      title: 'Warranty Comm Date',
                      subTitle: DateFormat(
                        'dd MMM yyyy',
                      ).format(project.warrantyCommDate!.toDate()),
                    ),
                  ],
                ),
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Created By',
                      subTitle: project.createdBy,
                      bottom: 0,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Created At',
                    subTitle: DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(project.createdAt.toDate()),
                    bottom: 0,
                  ),
                ],
              ),
              SizedBox(height: project.updatedAt != null ? 16 : 0),
              if (project.updatedAt != null)
                ProjectTextWidget(
                  title: 'Updated At',
                  subTitle: DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(project.updatedAt!.toDate()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavWidget(BuildContext context, ProjectEntity project) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            SizedBox(height: 50),
            ButtonWidget(
              onPressed: () async {
                final changed = await context.pushNamed(
                  AppRoutes.formProject,
                  extra: project,
                );
                if (changed == true && context.mounted) {
                  context.pop(true);
                }
              },
              background: AppColors.orange,
              title: 'Update project',
              fontSize: 16,
            ),
            SizedBox(height: 16),
            ButtonWidget(
              onPressed: () async {
                final actionCubit = context.read<ActionButtonCubit>();
                final changed = await CenterModalWidget.display(
                  context: context,
                  title: 'Remove project',
                  subtitle: "Are you sure to remove ${project.projectName}?",
                  yesButton: 'Remove',
                  actionCubit: actionCubit,
                  yesButtonOnTap: () {
                    context.read<ActionButtonCubit>().execute(
                      usecase: DeleteProjectUseCase(),
                      params: project.projectId,
                    );
                    context.pop(true);
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
                    context.pop(true);
                  }
                }
              },
              background: AppColors.red,
              title: 'Delete project',
              fontSize: 16,
            ),
            SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
