import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/product/data/models/sperreAirSystemSolutions/sperre_air_system_solutions_form_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_system_solutions_entity.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirSystemSolutions/add_sperre_air_system_solutions_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirSystemSolutions/update_sperre_air_system_solutions_usecase.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirSystemSolutions/sperre_air_system_solutions_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddSperreAirSystemSolutionsPage extends StatelessWidget {
  final SperreAirSystemSolutionsEntity? product;
  AddSperreAirSystemSolutionsPage({super.key, this.product});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = product != null;
    final collection = 'Products';
    final document = 'tG6pN1yXcQwE9bJmRvUh';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = SperreAirSystemSolutionsFormCubit();
            if (isUpdate) c.hydrateFromEntity(product!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate
            ? 'Update Sperre-Air System Solutions'
            : 'Add Sperre-Air System Solutions',
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
                  SperreAirSystemSolutionsFormCubit,
                  SperreAirSystemSolutionsReq
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
                                  .read<SperreAirSystemSolutionsFormCubit>()
                                  .setProductUsage(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<SperreAirSystemSolutionsFormCubit>(),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          ItemSelectionModalWidget(
                            collection: collection,
                            document: document,
                            subCollection: 'Product Category',
                            selected: state.productCategory,
                            icon: PhosphorIconsBold.cardholder,
                            onSelected: (value) {
                              context
                                  .read<SperreAirSystemSolutionsFormCubit>()
                                  .setProductCategory(value.title);
                              context.pop();
                            },
                            extraProviders: [
                              BlocProvider.value(
                                value: context
                                    .read<SperreAirSystemSolutionsFormCubit>(),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(
                              field: 'Product Name',
                            ),
                            hintText: 'Product Name',
                            title: 'Product Name',
                            initialValue: state.productName,
                            suffixIcon: PhosphorIconsBold.keyboard,
                            onChanged: (v) => context
                                .read<SperreAirSystemSolutionsFormCubit>()
                                .setProductName(v),
                          ),
                          SizedBox(height: 32),
                          TextfieldWidget(
                            validator: AppValidators.required(
                              field: 'Product Explanation',
                            ),
                            hintText: 'Product Explanation',
                            title: 'Product Explanation',
                            maxLines: 5,
                            initialValue: state.productExplanation,
                            onChanged: (v) => context
                                .read<SperreAirSystemSolutionsFormCubit>()
                                .setProductExplanation(v),
                          ),
                          SizedBox(height: 50),
                          ActionButtonWidget(
                            onPressed: () {
                              final isValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (!isValid) return;

                              context.read<ActionButtonCubit>().execute(
                                usecase: isUpdate
                                    ? UpdateSperreAirSystemSolutionsUseCase()
                                    : AddSperreAirSystemSolutionsUseCase(),
                                params: context
                                    .read<SperreAirSystemSolutionsFormCubit>()
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
