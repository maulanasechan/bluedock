import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/helper/stringTrimmer/string_trimmer_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/input/radio_list_button.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/product/data/models/quantumFreshWaterGenerator/quantum_fresh_water_generator_form_req.dart';
import 'package:bluedock/features/product/domain/entities/quantum_fresh_water_generator_entity.dart';
import 'package:bluedock/features/product/domain/usecases/quantumFreshWaterGenerator/add_quantum_fresh_water_generator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/quantumFreshWaterGenerator/update_quantum_fresh_water_generator_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/quantumFreshWaterGenerator/quantum_fresh_water_generator_form_cubit.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddQuantumFreshWaterGeneratorPage extends StatelessWidget {
  final QuantumFreshWaterGeneratorEntity? product;
  AddQuantumFreshWaterGeneratorPage({super.key, this.product});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = product != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = QuantumFreshWaterGeneratorFormCubit();
            if (isUpdate) c.hydrateFromEntity(product!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        fontSizeTitle: 15,
        hideBack: false,
        appbarTitle: isUpdate
            ? 'Update Quantum-Fresh Water Generator'
            : 'Add Quantum-Fresh Water Generator',
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
                  QuantumFreshWaterGeneratorFormCubit,
                  QuantumFreshWaterGeneratorReq
                >(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemSelectionModalWidget(
                            collection: 'Products',
                            document: 'M3jvF7wXaZpL2yKsTbQr',
                            subCollection: 'Water Solution Type',
                            selected: state.waterSolutionType,
                            icon: PhosphorIconsBold.creditCard,
                            onSelected: (value) {
                              context
                                  .read<QuantumFreshWaterGeneratorFormCubit>()
                                  .setWaterSolutionType(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<
                                      QuantumFreshWaterGeneratorFormCubit
                                    >(),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(
                              field: 'Type Description',
                            ),
                            hintText: 'Type Description',
                            title: 'Type Description',
                            initialValue: state.typeDescription,
                            suffixIcon: PhosphorIconsBold.keyboard,
                            onChanged: (v) => context
                                .read<QuantumFreshWaterGeneratorFormCubit>()
                                .setTypeDescription(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Min. Production Capacity ( m3/day )',
                            title: 'Min. Production Capacity',
                            initialValue: removeCommas(
                              stripSuffix(
                                state.minProductionCapacity,
                                'm3/day',
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: PhosphorIconsBold.calendarMinus,
                            onChanged: (v) => context
                                .read<QuantumFreshWaterGeneratorFormCubit>()
                                .setMinProductionCapacity(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Max. Production Capacity ( m3/day )',
                            title: 'Max. Production Capacity',
                            initialValue: removeCommas(
                              stripSuffix(
                                state.maxProductionCapacity,
                                'm3/day',
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: PhosphorIconsBold.calendarPlus,
                            onChanged: (v) => context
                                .read<QuantumFreshWaterGeneratorFormCubit>()
                                .setMaxProductionCapacity(v),
                          ),
                          SizedBox(height: 24),
                          RadioListButton(
                            title: 'Tailor-Made design',
                            state: state.tailorMadeDesign,
                            onPressed: () => context
                                .read<QuantumFreshWaterGeneratorFormCubit>()
                                .setTailorMadeDesign(!state.tailorMadeDesign),
                          ),
                          SizedBox(height: 50),
                          ActionButtonWidget(
                            onPressed: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (!isValid) return;

                              context.read<ActionButtonCubit>().execute(
                                usecase: isUpdate
                                    ? UpdateQuantumFreshWaterGeneratorUseCase()
                                    : AddQuantumFreshWaterGeneratorUseCase(),
                                params: context
                                    .read<QuantumFreshWaterGeneratorFormCubit>()
                                    .state,
                              );
                            },
                            title: isUpdate
                                ? 'Update Product'
                                : 'Add New Product',
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
