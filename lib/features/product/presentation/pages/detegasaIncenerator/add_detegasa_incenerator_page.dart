import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/helper/stringTrimmer/string_trimmer_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/product/data/models/detegasaIncenerator/detegasa_incenerator_form_req.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_incenerator_entity.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaIncenerator/add_detegasa_incenerator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaIncenerator/update_detegasa_incenerator_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaIncenerator/detegasa_incenerator_form_cubit.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddDetegasaInceneratorPage extends StatelessWidget {
  final DetegasaInceneratorEntity? product;
  AddDetegasaInceneratorPage({super.key, this.product});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = product != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = DetegasaInceneratorFormCubit();
            if (isUpdate) c.hydrateFromEntity(product!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate
            ? 'Update Detegasa-Incenerator'
            : 'Add Detegasa-Incenerator',
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
                  DetegasaInceneratorFormCubit,
                  DetegasaInceneratorReq
                >(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemSelectionModalWidget(
                            collection: 'Products',
                            document: 'L9cX2bTfVgP5zRjYhMwQ',
                            subCollection: 'Product Usage',
                            selected: state.productUsage,
                            icon: PhosphorIconsBold.creditCard,
                            onSelected: (value) {
                              context
                                  .read<DetegasaInceneratorFormCubit>()
                                  .setProductUsage(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<DetegasaInceneratorFormCubit>(),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(
                              field: 'Product Model',
                            ),
                            hintText: 'Product Model',
                            title: 'Product Model',
                            initialValue: state.productModel,
                            suffixIcon: PhosphorIconsBold.keyboard,
                            onChanged: (v) => context
                                .read<DetegasaInceneratorFormCubit>()
                                .setProductModel(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Heat Generate ( KCAL/Hr )',
                            title: 'Heat Generate',
                            initialValue: removeCommas(
                              stripSuffix(state.heatGenerate, 'KCAL/Hr'),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: PhosphorIconsBold.thermometer,
                            onChanged: (v) => context
                                .read<DetegasaInceneratorFormCubit>()
                                .setHeatGenerate(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Power Rating ( KW )',
                            title: 'Power Rating',
                            initialValue: removeCommas(
                              stripSuffix(state.powerRating, 'KW'),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: PhosphorIconsBold.handFist,
                            onChanged: (v) => context
                                .read<DetegasaInceneratorFormCubit>()
                                .setPowerRating(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'IMO Sludge ( L/H )',
                            title: 'IMO Sludge',
                            initialValue: stripSuffix(state.imoSludge, 'L/H'),
                            suffixIcon: PhosphorIconsBold.washingMachine,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (v) => context
                                .read<DetegasaInceneratorFormCubit>()
                                .setImoSludge(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Solid Waste ( kg/h )',
                            title: 'Solid Waste',
                            initialValue: stripSuffix(state.solidWaste, 'kg/h'),
                            suffixIcon: PhosphorIconsBold.trash,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (v) => context
                                .read<DetegasaInceneratorFormCubit>()
                                .setSolidWaste(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.numberOrDecimal(),
                            hintText: 'Max. Burner Consumption ( kg/h )',
                            title: 'Max. Burner Consumption',
                            initialValue: stripSuffix(
                              state.maxBurnerConsumption,
                              'kg/h',
                            ),
                            suffixIcon: PhosphorIconsBold.blueprint,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*[.]?\d*$'),
                              ),
                            ],
                            onChanged: (v) => context
                                .read<DetegasaInceneratorFormCubit>()
                                .setMaxBurnerConsumption(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.numberOrDecimal(),
                            hintText: 'Max. Electric Power ( KW )',
                            title: 'Max. Electric Power',
                            initialValue: stripSuffix(
                              state.maxElectricPower,
                              'KW',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: PhosphorIconsBold.lightning,
                            onChanged: (v) => context
                                .read<DetegasaInceneratorFormCubit>()
                                .setMaxElectricPower(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Approx. Incenerator Weight ( kg )',
                            title: 'Approx. Incenerator Weight',
                            initialValue: removeCommas(
                              stripSuffix(state.approxInceneratorWeight, 'kg'),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: PhosphorIconsBold.barbell,
                            onChanged: (v) => context
                                .read<DetegasaInceneratorFormCubit>()
                                .setApproxInceneratorWeight(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Fan Weight',
                            title: 'Fan Weight',
                            initialValue: state.fanWeight,
                            suffixIcon: PhosphorIconsBold.fan,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (v) => context
                                .read<DetegasaInceneratorFormCubit>()
                                .setFanWeight(v),
                          ),
                          SizedBox(height: 50),
                          ActionButtonWidget(
                            onPressed: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (!isValid) return;

                              context.read<ActionButtonCubit>().execute(
                                usecase: isUpdate
                                    ? UpdateDetegasaInceneratorUseCase()
                                    : AddDetegasaInceneratorUseCase(),
                                params: context
                                    .read<DetegasaInceneratorFormCubit>()
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
