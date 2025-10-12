import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_cubit.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_state.dart';
import 'package:bluedock/features/project/presentation/widgets/project_card_widget.dart';
import 'package:bluedock/features/project/presentation/widgets/project_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ManageProjectPage extends StatelessWidget {
  const ManageProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProjectDisplayCubit()..displayProject(params: ''),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Manage Project',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        appbarAction: Builder(
          builder: (ctx) {
            return IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsFill.boat,
              iconSize: 24,
              onPressed: () async {
                final sperreCubit = ctx.read<ProjectDisplayCubit>();
                final changed = await ctx.pushNamed(AppRoutes.formProject);
                if (changed == true && ctx.mounted) {
                  sperreCubit.displayProject(params: '');
                }
              },
            );
          },
        ),
        body: Column(
          children: [
            Builder(
              builder: (context) {
                return TextfieldWidget(
                  prefixIcon: PhosphorIconsBold.magnifyingGlass,
                  borderRadius: 60,
                  iconColor: AppColors.darkBlue,
                  hintText: 'Search',
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<ProjectDisplayCubit>().displayInitial();
                    } else {
                      context.read<ProjectDisplayCubit>().displayProject(
                        params: value,
                      );
                    }
                  },
                );
              },
            ),
            SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<ProjectDisplayCubit, ProjectDisplayState>(
                builder: (context, state) {
                  if (state is ProjectDisplayLoading) {
                    return ProjectLoadingWidget();
                  }
                  if (state is ProjectDisplayFetched) {
                    if (state.listProject.isEmpty) {
                      return Center(
                        child: TextWidget(text: "There isn't any project."),
                      );
                    } else {
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return ProjectCardWidget(
                            project: state.listProject[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12);
                        },
                        itemCount: state.listProject.length,
                      );
                    }
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
