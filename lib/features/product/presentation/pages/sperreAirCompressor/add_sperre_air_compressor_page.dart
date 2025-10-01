import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_form_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_compressor_entity.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirCompressor/add_sperre_air_compressor_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirCompressor/sperre_air_compressor_form_cubit.dart';
import 'package:flutter/material.dart';
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
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Add Sperre-Air Compressor',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final router = GoRouter.of(context);

              Future.delayed(const Duration(milliseconds: 30), () {
                router.pushNamed(
                  AppRoutes.successProduct,
                  extra: {
                    'title': isUpdate
                        ? 'The product has been updated'
                        : 'New product has been added',
                    'routeName': AppRoutes.sperreAirCompressor,
                  },
                );
              });
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
                          TextfieldWidget(
                            validator: AppValidators.required(),
                            hintText: 'Product Usage',
                            title: 'Product Usage',
                            initialValue: state.productUsage,
                            suffixIcon: PhosphorIconsBold.identificationCard,
                            onChanged: (v) => context
                                .read<SperreAirCompressorFormCubit>()
                                .setProductUsage(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(),
                            hintText: 'Product Type',
                            title: 'Product Type',
                            initialValue: state.productType,
                            suffixIcon: PhosphorIconsBold.creditCard,
                            onChanged: (v) => context
                                .read<SperreAirCompressorFormCubit>()
                                .setProductType(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(),
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
                            validator: AppValidators.required(),
                            hintText: 'Cooling System',
                            title: 'Cooling System',
                            initialValue: state.coolingSystem,
                            suffixIcon: PhosphorIconsBold.thermometerCold,
                            onChanged: (v) => context
                                .read<SperreAirCompressorFormCubit>()
                                .setCoolingSystem(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(),
                            hintText: 'Charging Capacity ( m3/h )',
                            title: 'Charging Capacity on 50 Hz - 1500 rpm',
                            initialValue: state.chargingCapacity50Hz1500rpm,
                            suffixIcon: PhosphorIconsBold.chargingStation,
                            onChanged: (v) => context
                                .read<SperreAirCompressorFormCubit>()
                                .setChargingCapacity50Hz1500rpm(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(),
                            hintText: 'Max. Delivery Pressure ( Bar )',
                            title: 'Max. Delivery Pressure',
                            initialValue: state.maxDeliveryPressure,
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
                                usecase: AddSperreAirCompressorUseCase(),
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
