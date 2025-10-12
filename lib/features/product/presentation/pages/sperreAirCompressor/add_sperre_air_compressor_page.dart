import 'package:bluedock/common/helper/stringTrimmer/string_trimmer_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_form_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_compressor_entity.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirCompressor/add_sperre_air_compressor_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirCompressor/update_sperre_air_compressor_usecase.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirCompressor/sperre_air_compressor_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddSperreAirCompressorPage extends StatelessWidget {
  final SperreAirCompressorEntity? product;
  AddSperreAirCompressorPage({super.key, this.product});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = product != null;
    final collection = 'Products';
    final document = 'aP9xG7kLmQzR2VtYcJwE';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = SperreAirCompressorFormCubit();
            if (isUpdate) c.hydrateFromEntity(product!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate
            ? 'Update Sperre-Air Compressor'
            : 'Add Sperre-Air Compressor',
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
                  SperreAirCompressorFormCubit,
                  SperreAirCompressorReq
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
                                  .read<SperreAirCompressorFormCubit>()
                                  .setProductUsage(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<SperreAirCompressorFormCubit>(),
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
                                  .read<SperreAirCompressorFormCubit>()
                                  .setProductType(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<SperreAirCompressorFormCubit>(),
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
                                  .read<SperreAirCompressorFormCubit>()
                                  .setCoolingSystem(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<SperreAirCompressorFormCubit>(),
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
                                .read<SperreAirCompressorFormCubit>()
                                .setProductTypeCode(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Charging Capacity ( m3/h )',
                            title: 'Charging Capacity on 50 Hz - 1500 rpm',
                            initialValue: stripSuffix(
                              state.chargingCapacity50Hz1500rpm,
                              'm3/h',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: PhosphorIconsBold.chargingStation,
                            onChanged: (v) => context
                                .read<SperreAirCompressorFormCubit>()
                                .setChargingCapacity50Hz1500rpm(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Max. Delivery Pressure ( Bar )',
                            title: 'Max. Delivery Pressure',
                            initialValue: stripSuffix(
                              state.maxDeliveryPressure,
                              'Bar',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: PhosphorIconsBold.gauge,
                            onChanged: (v) => context
                                .read<SperreAirCompressorFormCubit>()
                                .setMaxDeliveryPressure(v),
                          ),
                          SizedBox(height: 50),
                          ActionButtonWidget(
                            onPressed: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (!isValid) return;

                              context.read<ActionButtonCubit>().execute(
                                usecase: isUpdate
                                    ? UpdateSperreAirCompressorUseCase()
                                    : AddSperreAirCompressorUseCase(),
                                params: context
                                    .read<SperreAirCompressorFormCubit>()
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
