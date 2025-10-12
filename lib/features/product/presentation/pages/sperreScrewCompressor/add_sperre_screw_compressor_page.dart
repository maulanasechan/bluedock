import 'package:bluedock/common/helper/stringTrimmer/string_trimmer_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/product/data/models/sperreScrewCompressor/sperre_screw_compressor_form_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_screw_compressor_entity.dart';
import 'package:bluedock/features/product/domain/usecases/sperreScrewCompressor/add_sperre_screw_compressor_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreScrewCompressor/update_sperre_screw_compressor_usecase.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreScrewCompressor/sperre_screw_compressor_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddSperreScrewCompressorPage extends StatelessWidget {
  final SperreScrewCompressorEntity? product;
  AddSperreScrewCompressorPage({super.key, this.product});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = product != null;
    final collection = 'Products';
    final document = 'Zx4nB8qHtUvL5rOaWsKd';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = SperreScrewCompressorFormCubit();
            if (isUpdate) c.hydrateFromEntity(product!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate
            ? 'Update Sperre-Screw Compressor'
            : 'Add Sperre-Screw Compressor',
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
                  SperreScrewCompressorFormCubit,
                  SperreScrewCompressorReq
                >(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ItemSelectionModalWidget(
                            collection: collection,
                            document: document,
                            subCollection: 'Product Usage',
                            selected: state.productUsage,
                            icon: PhosphorIconsBold.creditCard,
                            onSelected: (value) {
                              context
                                  .read<SperreScrewCompressorFormCubit>()
                                  .setProductUsage(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<SperreScrewCompressorFormCubit>(),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          ItemSelectionModalWidget(
                            collection: collection,
                            document: document,
                            subCollection: 'Product Type',
                            selected: state.productType,
                            icon: PhosphorIconsBold.cardholder,
                            onSelected: (value) {
                              context
                                  .read<SperreScrewCompressorFormCubit>()
                                  .setProductType(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<SperreScrewCompressorFormCubit>(),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          ItemSelectionModalWidget(
                            collection: collection,
                            document: document,
                            subCollection: 'Cooling System',
                            selected: state.coolingSystem,
                            icon: PhosphorIconsBold.thermometerCold,
                            onSelected: (value) {
                              context
                                  .read<SperreScrewCompressorFormCubit>()
                                  .setCoolingSystem(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<SperreScrewCompressorFormCubit>(),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(
                              field: 'Product Type Code',
                            ),
                            hintText: 'Product Type Code',
                            title: 'Product Type Code',
                            initialValue: state.productTypeCode,
                            suffixIcon: PhosphorIconsBold.keyboard,
                            onChanged: (v) => context
                                .read<SperreScrewCompressorFormCubit>()
                                .setProductTypeCode(v),
                          ),
                          SizedBox(height: 32),
                          TextfieldWidget(
                            validator: AppValidators.numberOrRange(),
                            hintText: 'Charging Capacity - 8 Bar ( m3/h )',
                            title:
                                'Charging Capacity for Working Pressure 8 Bar',
                            initialValue: stripSuffix(
                              state.chargingCapacity8Bar,
                              'm3/h',
                            ),
                            suffixIcon: PhosphorIconsBold.batteryVerticalMedium,
                            onChanged: (v) => context
                                .read<SperreScrewCompressorFormCubit>()
                                .setChargingCapacity8Bar(v),
                          ),
                          SizedBox(height: 32),
                          TextfieldWidget(
                            validator: AppValidators.numberOrRange(),
                            hintText: 'Charging Capacity - 10 Bar ( m3/h )',
                            title:
                                'Charging Capacity for Working Pressure 10 Bar',
                            initialValue: stripSuffix(
                              state.chargingCapacity10Bar,
                              'm3/h',
                            ),
                            suffixIcon: PhosphorIconsBold.batteryVerticalHigh,
                            onChanged: (v) => context
                                .read<SperreScrewCompressorFormCubit>()
                                .setChargingCapacity10Bar(v),
                          ),
                          SizedBox(height: 32),
                          TextfieldWidget(
                            validator: AppValidators.numberOrRange(),
                            hintText: 'Charging Capacity - 12.5 Bar ( m3/h )',
                            title:
                                'Charging Capacity for Working Pressure 12.5 Bar',
                            initialValue: stripSuffix(
                              state.chargingCapacity12_5Bar,
                              'm3/h',
                            ),
                            suffixIcon: PhosphorIconsBold.batteryVerticalFull,
                            onChanged: (v) => context
                                .read<SperreScrewCompressorFormCubit>()
                                .setChargingCapacity12_5Bar(v),
                          ),
                          SizedBox(height: 50),
                          ActionButtonWidget(
                            onPressed: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (!isValid) return;

                              context.read<ActionButtonCubit>().execute(
                                usecase: isUpdate
                                    ? UpdateSperreScrewCompressorUseCase()
                                    : AddSperreScrewCompressorUseCase(),
                                params: context
                                    .read<SperreScrewCompressorFormCubit>()
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
