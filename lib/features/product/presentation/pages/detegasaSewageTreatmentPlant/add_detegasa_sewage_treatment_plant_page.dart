import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/helper/stringTrimmer/string_trimmer_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/widgets/dropdown_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/product/data/models/detegasaSewageTreatmentPlant/detegasa_sewage_treatment_plant_form_req.dart';
import 'package:bluedock/features/product/data/models/selection/selection_req.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_sewage_treatment_plant_entity.dart';
import 'package:bluedock/features/product/domain/entities/selection_entity.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaSewageTreatmentPlant/add_detegasa_sewage_treatment_plant_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaSewageTreatmentPlant/update_detegasa_sewage_treatment_plant_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaSewageTreatmentPlant/detegasa_sewage_treatment_plant_form_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/selection/selection_display_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/list_selection_button_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/selection_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddDetegasaSewageTreatmentPlantPage extends StatelessWidget {
  final DetegasaSewageTreatmentPlantEntity? product;
  AddDetegasaSewageTreatmentPlantPage({super.key, this.product});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = product != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = DetegasaSewageTreatmentPlantFormCubit();
            if (isUpdate) c.hydrateFromEntity(product!);
            return c;
          },
        ),
        BlocProvider(create: (context) => SelectionDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate
            ? 'Update Detegasa-Sewage Treatment Plant'
            : 'Add Detegasa-Sewage Treatment Plant',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) async {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final changed = await context.pushNamed(
                AppRoutes.successProduct,
                extra: {
                  'title': isUpdate
                      ? 'Product has been updated'
                      : 'New product has been added',
                },
              );
              if (changed == true && context.mounted) {
                context.pop(true);
              }
            }
          },
          child: SingleChildScrollView(
            child:
                BlocBuilder<
                  DetegasaSewageTreatmentPlantFormCubit,
                  DetegasaSewageTreatmentPlantReq
                >(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _selectionDropdown(
                            context: context,
                            title: 'Product Usage',
                            selected: state.productUsage,
                            icon: PhosphorIconsBold.creditCard,
                            onPressed: (value) {
                              context
                                  .read<DetegasaSewageTreatmentPlantFormCubit>()
                                  .setProductUsage(value.title);
                              context.pop();
                            },
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(),
                            hintText: 'Product Model',
                            title: 'Product Model',
                            initialValue: state.productModel,
                            suffixIcon: PhosphorIconsBold.keyboard,
                            onChanged: (v) => context
                                .read<DetegasaSewageTreatmentPlantFormCubit>()
                                .setProductModel(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Product Crew ( Person )',
                            title: 'Product Crew',
                            initialValue: stripSuffix(
                              state.productCrew,
                              'Person',
                            ),
                            suffixIcon: PhosphorIconsBold.usersThree,
                            onChanged: (v) => context
                                .read<DetegasaSewageTreatmentPlantFormCubit>()
                                .setProductCrew(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Product Capacity ( L/Day )',
                            title: 'Product Capacity',
                            initialValue: removeCommas(
                              stripSuffix(state.productCapacity, 'L/Day'),
                            ),
                            suffixIcon: PhosphorIconsBold.frameCorners,
                            onChanged: (v) => context
                                .read<DetegasaSewageTreatmentPlantFormCubit>()
                                .setProductCapacity(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.numberOrDecimal(),
                            hintText: 'Kilograms ( KGBOD/Day )',
                            title: 'Kilograms of Biochemical Oxygen',
                            initialValue: stripSuffix(
                              state.kilogramsOfBiochemicalOxygen,
                              'KGBOD/Day',
                            ),
                            suffixIcon: PhosphorIconsBold.calendarX,
                            onChanged: (v) => context
                                .read<DetegasaSewageTreatmentPlantFormCubit>()
                                .setKilogramsOfBiochemicalOxygen(v),
                          ),
                          SizedBox(height: 50),
                          ActionButtonWidget(
                            onPressed: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (!isValid) return;

                              context.read<ActionButtonCubit>().execute(
                                usecase: isUpdate
                                    ? UpdateDetegasaSewageTreatmentPlantUseCase()
                                    : AddDetegasaSewageTreatmentPlantUseCase(),
                                params: context
                                    .read<
                                      DetegasaSewageTreatmentPlantFormCubit
                                    >()
                                    .state,
                              );
                            },
                            title: isUpdate
                                ? 'Update Product'
                                : 'Add New Product',
                            fontSize: 16,
                          ),
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

  Widget _selectionDropdown({
    required BuildContext context,
    required String title,
    required String selected,
    required void Function(SelectionEntity) onPressed,
    required PhosphorIconData icon,
  }) {
    return DropdownWidget(
      icon: icon,
      title: title,
      state: selected == '' ? title : selected,
      validator: (_) => selected == '' ? '$title is required.' : null,
      onTap: () {
        BottomModalWidget.display(
          context,
          MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: context.read<DetegasaSewageTreatmentPlantFormCubit>(),
              ),
              BlocProvider.value(
                value: context.read<SelectionDisplayCubit>()
                  ..displaySelection(
                    SelectionReq(
                      categoryId: 'qY8kH4mTzRpG6nVxWdJo',
                      selectionTitle: title,
                    ),
                  ),
              ),
            ],
            child: SelectionModalWidget(
              title: 'Choose one $title:',
              builder: (context, listSelection) {
                return BlocBuilder<
                  DetegasaSewageTreatmentPlantFormCubit,
                  DetegasaSewageTreatmentPlantReq
                >(
                  builder: (context, state) {
                    return ListSelectionButtonWidget(
                      listSelection: listSelection,
                      selected: selected,
                      onSelected: onPressed,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
