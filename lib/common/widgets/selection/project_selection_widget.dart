import 'package:bluedock/common/bloc/projectSection/project_display_cubit.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_state.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/dropdown_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProjectSelectionWidget extends StatelessWidget {
  final String title;
  final String selected;
  final void Function(ProjectEntity) onPressed;
  final PhosphorIconData? icon;
  final double heightButton;
  final List<BlocProvider> extraProviders;
  final bool? withoutTitle;
  final String? status;

  const ProjectSelectionWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onPressed,
    this.icon,
    this.heightButton = 80,
    required this.extraProviders,
    this.withoutTitle = false,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownWidget(
      icon: icon,
      title: withoutTitle! ? null : title,
      state: selected == '' ? title : selected,
      validator: (_) => selected == '' ? '$title is required.' : null,
      onTap: () {
        BottomModalWidget.display(
          context,
          height: MediaQuery.of(context).size.height,
          MultiBlocProvider(
            providers: [
              ...extraProviders,
              BlocProvider.value(
                value: context.read<ProjectDisplayCubit>()..displayInitial(),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Choose one $title:',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  const SizedBox(height: 24),
                  TextfieldWidget(
                    prefixIcon: PhosphorIconsBold.magnifyingGlass,
                    borderRadius: 60,
                    iconColor: AppColors.darkBlue,
                    hintText: 'Search',
                    onChanged: (value) {
                      context.read<ProjectDisplayCubit>().setKeyword(value);
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: BlocBuilder<ProjectDisplayCubit, ProjectDisplayState>(
                      builder: (context, state) {
                        if (state is ProjectDisplayLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is ProjectDisplayFailure) {
                          return Center(child: Text(state.message));
                        }
                        if (state is ProjectDisplayFetched) {
                          final activeProjects = status == null
                              ? state.listProject
                              : state.listProject
                                    .where((p) => p.status != status)
                                    .toList();

                          if (activeProjects.isEmpty) {
                            return const Center(
                              child: Text('No active project found'),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.only(bottom: 3),
                            itemCount: activeProjects.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 20),
                            itemBuilder: (context, index) {
                              final value = activeProjects[index];
                              final isSelected = selected == value.projectName;
                              return ButtonWidget(
                                height: heightButton,
                                background: isSelected
                                    ? AppColors.blue
                                    : AppColors.white,
                                onPressed: () => onPressed(value),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                text:
                                                    "${value.customerCompany} - ${value.projectName}",
                                                color: isSelected
                                                    ? AppColors.white
                                                    : AppColors.darkBlue,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              SizedBox(height: 8),
                                              TextWidget(
                                                text:
                                                    '${value.productCategory.title} - ${value.productSelection.productModel}',
                                                color: isSelected
                                                    ? AppColors.white
                                                    : AppColors.darkBlue,
                                                overflow: TextOverflow.fade,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextWidget(
                                          text:
                                              "${value.quantity.toInt()} Unit",
                                          overflow: TextOverflow.fade,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? AppColors.white
                                              : AppColors.orange,
                                          fontSize: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
