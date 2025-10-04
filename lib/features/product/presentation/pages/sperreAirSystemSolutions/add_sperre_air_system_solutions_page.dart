import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/widgets/dropdown_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/product/data/models/selection/selection_req.dart';
import 'package:bluedock/features/product/data/models/sperreAirSystemSolutions/sperre_air_system_solutions_form_req.dart';
import 'package:bluedock/features/product/domain/entities/selection_entity.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_system_solutions_entity.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirSystemSolutions/add_sperre_air_system_solutions_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirSystemSolutions/update_sperre_air_system_solutions_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/selection/selection_display_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirSystemSolutions/sperre_air_system_solutions_form_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/list_selection_button_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/selection_modal_widget.dart';
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
        BlocProvider(create: (context) => SelectionDisplayCubit()),
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
                          _selectionDropdown(
                            context: context,
                            title: 'Product Usage',
                            selected: state.productUsage,
                            icon: PhosphorIconsBold.creditCard,
                            onPressed: (value) {
                              context
                                  .read<SperreAirSystemSolutionsFormCubit>()
                                  .setProductUsage(value.title);
                              context.pop();
                            },
                          ),
                          SizedBox(height: 24),
                          _selectionDropdown(
                            context: context,
                            title: 'Product Category',
                            selected: state.productCategory,
                            icon: PhosphorIconsBold.cardholder,
                            onPressed: (value) {
                              context
                                  .read<SperreAirSystemSolutionsFormCubit>()
                                  .setProductCategory(value.title);
                              context.pop();
                            },
                          ),
                          SizedBox(height: 24),
                          TextfieldWidget(
                            validator: AppValidators.required(),
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
                            validator: AppValidators.required(),
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
                value: context.read<SperreAirSystemSolutionsFormCubit>(),
              ),
              BlocProvider.value(
                value: context.read<SelectionDisplayCubit>()
                  ..displaySelection(
                    SelectionReq(
                      categoryId: 'tG6pN1yXcQwE9bJmRvUh',
                      selectionTitle: title,
                    ),
                  ),
              ),
            ],
            child: SelectionModalWidget(
              title: 'Choose one $title:',
              builder: (context, listSelection) {
                return BlocBuilder<
                  SperreAirSystemSolutionsFormCubit,
                  SperreAirSystemSolutionsReq
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
