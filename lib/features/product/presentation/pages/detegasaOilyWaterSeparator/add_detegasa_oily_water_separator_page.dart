import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/helper/stringTrimmer/string_trimmer_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/product/data/models/detegasaOilyWaterSeparator/detegasa_oily_water_separator_form_req.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_oily_water_separator_entity.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaOilyWaterSeparator/add_detegasa_oily_water_separator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaOilyWaterSeparator/update_detegasa_oily_water_separator_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaOilyWaterSeparator/detegasa_oily_water_separator_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddDetegasaOilyWaterSeparatorPage extends StatelessWidget {
  final DetegasaOilyWaterSeparatorEntity? product;
  AddDetegasaOilyWaterSeparatorPage({super.key, this.product});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = product != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = DetegasaOilyWaterSeparatorFormCubit();
            if (isUpdate) c.hydrateFromEntity(product!);
            return c;
          },
        ),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate
            ? 'Update Detegasa-Oily Water Separator'
            : 'Add Detegasa-Oily Water Separator',
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
                  DetegasaOilyWaterSeparatorFormCubit,
                  DetegasaOilyWaterSeparatorReq
                >(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextfieldWidget(
                            validator: AppValidators.required(),
                            hintText: 'Product Model',
                            title: 'Product Model',
                            initialValue: state.productModel,
                            suffixIcon: PhosphorIconsBold.keyboard,
                            onChanged: (v) => context
                                .read<DetegasaOilyWaterSeparatorFormCubit>()
                                .setProductModel(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.numberOrDecimal(),
                            hintText: 'Product Capacity ( m3/h )',
                            title: 'Product Capacity ( m3/h )',
                            initialValue: stripSuffix(
                              state.productCapacity,
                              'm3/h',
                            ),
                            suffixIcon: PhosphorIconsBold.stack,
                            onChanged: (v) => context
                                .read<DetegasaOilyWaterSeparatorFormCubit>()
                                .setProductCapacity(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Product Length ( mm )',
                            title: 'Product Length ( mm )',
                            initialValue: removeCommas(
                              stripSuffix(state.productLength, 'mm'),
                            ),
                            suffixIcon: PhosphorIconsBold.ruler,
                            onChanged: (v) => context
                                .read<DetegasaOilyWaterSeparatorFormCubit>()
                                .setProductLength(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Product Width ( mm )',
                            title: 'Product Width ( mm )',
                            initialValue: removeCommas(
                              stripSuffix(state.productWidth, 'mm'),
                            ),
                            suffixIcon: PhosphorIconsBold.ruler,
                            onChanged: (v) => context
                                .read<DetegasaOilyWaterSeparatorFormCubit>()
                                .setProductWidth(v),
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.number(),
                            hintText: 'Product Height ( mm )',
                            title: 'Product Height ( mm )',
                            initialValue: removeCommas(
                              stripSuffix(state.productHeight, 'mm'),
                            ),
                            suffixIcon: PhosphorIconsBold.ruler,
                            onChanged: (v) => context
                                .read<DetegasaOilyWaterSeparatorFormCubit>()
                                .setProductHeight(v),
                          ),
                          SizedBox(height: 50),
                          ActionButtonWidget(
                            onPressed: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (!isValid) return;

                              context.read<ActionButtonCubit>().execute(
                                usecase: isUpdate
                                    ? UpdateDetegasaOilyWaterSeparatorUseCase()
                                    : AddDetegasaOilyWaterSeparatorUseCase(),
                                params: context
                                    .read<DetegasaOilyWaterSeparatorFormCubit>()
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
