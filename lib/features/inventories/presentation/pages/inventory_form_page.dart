import 'package:bluedock/common/bloc/productSection/product_section_cubit.dart';
import 'package:bluedock/common/bloc/staff/staff_display_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/selection/product_category_selection_widget.dart';
import 'package:bluedock/common/widgets/selection/product_selection_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/inventories/data/models/inventory_form_req.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:bluedock/features/inventories/domain/usecases/add_inventory_usecase.dart';
import 'package:bluedock/features/inventories/domain/usecases/update_inventory_usecase.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class InventoryFormPage extends StatelessWidget {
  final InventoryEntity? inventory;
  InventoryFormPage({super.key, this.inventory});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = inventory != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = InventoryFormCubit();
            if (isUpdate) c.hydrateFromEntity(inventory!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ProductSectionCubit()),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
        BlocProvider(create: (context) => StaffDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate ? 'Update inventory' : 'Add inventory',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) async {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final changed = await context.pushNamed(
                AppRoutes.inventorySuccess,
                extra: {
                  'title': isUpdate
                      ? 'Inventory has been updated'
                      : 'New inventory has been added',
                },
              );
              if (changed == true && context.mounted) {
                context.pop(true);
              }
            }
          },
          child: SingleChildScrollView(
            child: BlocBuilder<InventoryFormCubit, InventoryFormReq>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductCategorySelectionWidget(
                        title: 'Product Category',
                        selected: state.productCategory?.title ?? '',
                        onPressed: (value) {
                          context.read<InventoryFormCubit>().setProductCategory(
                            value,
                          );
                          context.pop();
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<InventoryFormCubit>(),
                          ),
                        ],
                        icon: PhosphorIconsBold.archive,
                      ),
                      SizedBox(height: 24),
                      ProductSelectionWidget(
                        title: 'Product Model',
                        categoryId: state.productCategory?.categoryId ?? '',
                        selected: state.productSelection?.productModel ?? '',
                        onPressed: (value) {
                          context
                              .read<InventoryFormCubit>()
                              .setProductSelection(value);
                          context.pop();
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<InventoryFormCubit>(),
                          ),
                        ],
                        icon: PhosphorIconsBold.washingMachine,
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.required(field: 'Part Number'),
                        hintText: 'Part Number',
                        title: 'Part Number',
                        initialValue: state.partNo,
                        suffixIcon: PhosphorIconsBold.cardholder,
                        onChanged: (v) =>
                            context.read<InventoryFormCubit>().setPartNo(v),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.required(field: 'Name'),
                        hintText: 'Name',
                        title: 'Name',
                        initialValue: state.stockName,
                        suffixIcon: PhosphorIconsBold.cardsThree,
                        onChanged: (v) =>
                            context.read<InventoryFormCubit>().setStockName(v),
                      ),
                      SizedBox(height: 24),
                      TextWidget(
                        text: 'Price and Currency',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 65,
                            child: ItemSelectionModalWidget(
                              withoutIcon: true,
                              withoutTitle: true,
                              align: TextAlign.center,
                              collection: 'Selection',
                              document: 'List Selection',
                              subCollection: 'Currency',
                              selected: state.currency,
                              icon: PhosphorIconsBold.creditCard,
                              onSelected: (value) {
                                context.read<InventoryFormCubit>().setCurrency(
                                  value.title,
                                );
                                context.pop();
                              },
                              extraProviders: [
                                BlocProvider.value(
                                  value: context.read<InventoryFormCubit>(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextfieldWidget(
                              validator: AppValidators.number(),
                              hintText: 'Price',
                              initialValue: state.price == null
                                  ? ''
                                  : state.price.toString(),
                              suffixIcon: PhosphorIconsBold.moneyWavy,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (v) => context
                                  .read<InventoryFormCubit>()
                                  .setPrice(int.parse(v)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.number(),
                        hintText: 'Stock Quantity',
                        title: 'Stock Quantity',
                        initialValue: state.quantity.toString(),
                        suffixIcon: PhosphorIconsBold.package,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (v) => context
                            .read<InventoryFormCubit>()
                            .setQuantity(int.parse(v)),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: 'Maintenance Period',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),

                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: state.needMaintenance,
                              onChanged: (v) {
                                final cubit = context
                                    .read<InventoryFormCubit>();
                                cubit
                                  ..setMaintenancePeriod(null)
                                  ..setNeedMaintenance(v);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      if (state.needMaintenance)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextfieldWidget(
                                validator: AppValidators.number(),
                                hintText: 'Maintenance Period',
                                initialValue: state.maintenancePeriod == null
                                    ? ''
                                    : state.maintenancePeriod.toString(),
                                suffixIcon: PhosphorIconsBold.calendarCheck,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (v) => context
                                    .read<InventoryFormCubit>()
                                    .setMaintenancePeriod(int.tryParse(v)),
                              ),
                            ),
                            SizedBox(width: 12),
                            SizedBox(
                              width: 80,
                              child: TextfieldWidget(
                                initialValue: state.maintenanceCurrency,
                                disabled: true,
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
                                ? UpdateInventoryUseCase()
                                : AddInventoryUseCase(),
                            params: context.read<InventoryFormCubit>().state,
                          );
                        },
                        title: isUpdate
                            ? 'Update Inventory'
                            : 'Add New Inventory',
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
