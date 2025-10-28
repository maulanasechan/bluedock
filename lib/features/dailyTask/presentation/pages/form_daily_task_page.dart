import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_cubit.dart';
import 'package:bluedock/common/bloc/staff/staff_display_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/dateTimePicker/date_picker_widget.dart';
import 'package:bluedock/common/widgets/dateTimePicker/time_picker_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/project_selection_widget.dart';
import 'package:bluedock/common/widgets/selection/staff_selection_widget.dart';
import 'package:bluedock/common/widgets/selection/type_category_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/dailyTask/data/models/daily_task_form_req.dart';
import 'package:bluedock/features/dailyTask/domain/entities/daily_task_entity.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/add_daily_task_usecase.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/update_detegasa_incenerator_usecase.dart';
import 'package:bluedock/features/dailyTask/presentation/bloc/dailyTask/daily_task_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FormDailyTaskPage extends StatelessWidget {
  final DailyTaskEntity? task;
  FormDailyTaskPage({super.key, this.task});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = task != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = DailyTaskFormCubit();
            if (isUpdate) c.hydrateFromEntity(task!);
            return c;
          },
        ),
        BlocProvider(create: (context) => StaffDisplayCubit()),
        BlocProvider(create: (context) => ProjectDisplayCubit()),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate ? 'Update Daily Task' : 'Add Daily Task',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) async {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final changed = await context.pushNamed(
                AppRoutes.successDaily,
                extra: {
                  'title': isUpdate
                      ? 'Daily task has been updated'
                      : 'New daily task has been added',
                },
              );
              if (changed == true && context.mounted) {
                context.pop(true);
              }
            }
          },
          child: SingleChildScrollView(
            child: BlocBuilder<DailyTaskFormCubit, DailyTaskFormReq>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextfieldWidget(
                        validator: AppValidators.required(field: 'Title'),
                        hintText: 'Title',
                        title: 'Title',
                        initialValue: state.title,
                        suffixIcon: PhosphorIconsBold.keyboard,
                        onChanged: (v) =>
                            context.read<DailyTaskFormCubit>().setTitle(v),
                      ),
                      if (isUpdate == false) SizedBox(height: 24),
                      if (isUpdate == false)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: 'Using Project Reference',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),

                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: state.projectReference,
                                onChanged: (v) {
                                  final cubit = context
                                      .read<DailyTaskFormCubit>();
                                  cubit
                                    ..setProjectName('')
                                    ..setCustomerCompany('')
                                    ..setProjectModel('')
                                    ..setProjectCategory('')
                                    ..setProjectDescription('')
                                    ..setProjectRef(v)
                                    ..clearTaskCategory();
                                },
                              ),
                            ),
                          ],
                        ),
                      if (state.projectReference == true)
                        Column(
                          children: [
                            SizedBox(height: isUpdate ? 24 : 12),
                            ProjectSelectionWidget(
                              title: 'Project Reference',
                              withoutTitle: isUpdate ? false : true,
                              selected: state.projectName,
                              onPressed: (v) {
                                final cubit = context
                                    .read<DailyTaskFormCubit>();
                                cubit
                                  ..setProjectName(v.projectName)
                                  ..setCustomerCompany(v.customerCompany)
                                  ..setProjectModel(
                                    v.productSelection.productModel,
                                  )
                                  ..setProjectCategory(v.productCategory.title)
                                  ..setProjectDescription(v.projectDescription);
                                context.pop();
                              },
                              extraProviders: [
                                BlocProvider.value(
                                  value: context.read<DailyTaskFormCubit>(),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            TypeCategorySelectionModalWidget(
                              collection: 'Selection',
                              subCollection: 'Type Categories',
                              document: 'List Selection',
                              selected: state.dailyTaskCategory?.title ?? '',
                              onSelected: (v) {
                                context
                                    .read<DailyTaskFormCubit>()
                                    .setTaskCategory(v);
                                context.pop();
                              },
                              icon: PhosphorIconsBold.listMagnifyingGlass,
                              extraProviders: [
                                BlocProvider.value(
                                  value: context.read<DailyTaskFormCubit>(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        hintText: 'Description',
                        title: 'Description',
                        maxLines: 4,
                        initialValue: state.description,
                        suffixIcon: PhosphorIconsBold.articleMedium,
                        onChanged: (v) => context
                            .read<DailyTaskFormCubit>()
                            .setDescription(v),
                      ),
                      SizedBox(height: 24),
                      StaffSelectionWidget(
                        title: 'Participants',
                        selected: state.listParticipant,
                        onPressed: (value) {
                          context
                              .read<DailyTaskFormCubit>()
                              .toggleParticipantByEntity(value);
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<DailyTaskFormCubit>(),
                          ),
                        ],
                        icon: PhosphorIconsBold.userList,
                      ),
                      SizedBox(height: 24),
                      DatePickerWidget(
                        title: 'Date',
                        selected: state.date,
                        onChanged: (d) =>
                            context.read<DailyTaskFormCubit>().setDate(d),
                      ),
                      SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TimePickerWidget(
                              title: 'Start Time',
                              selected: state.startTime,
                              validator: AppValidators.requiredTime(
                                field: 'Start time',
                              ),
                              onChanged: (t) => context
                                  .read<DailyTaskFormCubit>()
                                  .setStartTime(t),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TimePickerWidget(
                              title: 'End Time',
                              selected: state.endTime,
                              validator: AppValidators.endAfterStart(
                                date: state.date,
                                start: state.startTime,
                                requiredMsg: 'End time is required.',
                                invalidMsg:
                                    'End time must be later than start time.',
                              ),
                              onChanged: (t) => context
                                  .read<DailyTaskFormCubit>()
                                  .setEndTime(t),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      ActionButtonWidget(
                        onPressed: () {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) return;

                          context.read<ActionButtonCubit>().execute(
                            usecase: isUpdate
                                ? UpdateDailyTaskUseCase()
                                : AddDailyTaskUseCase(),
                            params: context.read<DailyTaskFormCubit>().state,
                          );
                        },
                        title: isUpdate ? 'Update Task' : 'Add New Task',
                        fontSize: 16,
                      ),
                      SizedBox(height: 6),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
