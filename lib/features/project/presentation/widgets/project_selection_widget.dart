import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/widgets/dropdown_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/project/data/models/project_form_req.dart';
import 'package:bluedock/features/project/domain/entities/selection/project_selection_entity.dart';
import 'package:bluedock/features/project/presentation/bloc/project/project_form_cubit.dart';
import 'package:bluedock/features/project/presentation/bloc/selection/project_selection_display_cubit.dart';
import 'package:bluedock/features/project/presentation/bloc/selection/project_selection_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProjectSelectionWidget extends StatelessWidget {
  final String title;
  final String selected;
  final void Function(ProjectSelectionEntity) onPressed;
  final PhosphorIconData? icon;
  final double? heightButton;
  final bool? withoutIcon;
  final bool? withoutTitle;
  final TextAlign? align;
  const ProjectSelectionWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onPressed,
    this.withoutTitle = false,
    this.icon,
    this.heightButton = 50,
    this.withoutIcon = false,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownWidget(
      align: align,
      icon: icon,
      title: withoutTitle! ? null : title,
      state: selected == '' ? title : selected,
      validator: (_) => selected == '' ? '$title is required.' : null,
      withoutIcon: withoutIcon,
      onTap: () {
        BottomModalWidget.display(
          context,
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<ProjectFormCubit>()),
              BlocProvider.value(
                value: context.read<ProjectSelectionDisplayCubit>()
                  ..displaySelection(title),
              ),
            ],
            child:
                BlocBuilder<
                  ProjectSelectionDisplayCubit,
                  ProjectSelectionDisplayState
                >(
                  builder: (context, state) {
                    if (state is ProjectSelectionDisplayLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is ProjectSelectionDisplayFailure) {
                      return Center(child: Text(state.message));
                    }
                    if (state is ProjectSelectionDisplayFetched) {
                      final listSelection = state.listSelection;
                      return BlocBuilder<ProjectFormCubit, ProjectFormReq>(
                        builder: (context, state) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: 'Choose one $title :',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                                SizedBox(height: 16),
                                Expanded(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    itemBuilder: (context, index) {
                                      final value = listSelection[index];
                                      return ButtonWidget(
                                        height: heightButton,
                                        background: selected == value.title
                                            ? AppColors.blue
                                            : AppColors.white,
                                        onPressed: () => onPressed(value),
                                        title: value.title,
                                        fontColor: selected == value.title
                                            ? AppColors.white
                                            : AppColors.darkBlue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 20),
                                    itemCount: listSelection.length,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return SizedBox();
                  },
                ),
          ),
        );
      },
    );
  }
}
