import 'package:bluedock/common/bloc/productSection/product_section_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/dateTimePicker/date_picker_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/common/widgets/selection/product_category_selection_widget.dart';
import 'package:bluedock/common/widgets/selection/product_selection_widget.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/add_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/fill_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/update_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PurchaseOrderFormPage extends StatelessWidget {
  final PurchaseOrderEntity? purchaseOrder;
  PurchaseOrderFormPage({super.key, this.purchaseOrder});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = purchaseOrder != null;
    final collection = 'Projects';
    final document = 'Selection';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = PurchaseOrderFormCubit();
            if (isUpdate) c.hydrateFromEntity(purchaseOrder!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ProductSectionCubit()),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate ? 'Update Purchase Order' : 'Add Purchase Order',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) async {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final changed = await context.pushNamed(
                AppRoutes.purchaseOrderSuccess,
                extra: {
                  'title': isUpdate
                      ? 'Purchase Order has been updated'
                      : 'New purchase order has been added',
                },
              );
              if (changed == true && context.mounted) {
                context.pop(true);
              }
            }
          },
          child: SingleChildScrollView(
            child: BlocBuilder<PurchaseOrderFormCubit, PurchaseOrderFormReq>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isUpdate)
                        TextfieldWidget(
                          disabled: isUpdate,
                          validator: AppValidators.required(
                            field: 'Purchase Contract Number',
                          ),
                          hintText: 'Purchase Contract Number',
                          title: 'Purchase Contract Number',
                          initialValue: state.purchaseContractNumber,
                          suffixIcon: PhosphorIconsBold.cardholder,
                          onChanged: (v) => context
                              .read<PurchaseOrderFormCubit>()
                              .setPurchaseContractNumber(v),
                        ),
                      if (isUpdate) SizedBox(height: 24),
                      if (isUpdate)
                        TextfieldWidget(
                          disabled: isUpdate,
                          validator: AppValidators.required(
                            field: 'Project Name',
                          ),
                          hintText: 'Project Name',
                          title: 'Project Name',
                          initialValue: state.projectName,
                          suffixIcon: PhosphorIconsBold.cardsThree,
                          onChanged: (v) => context
                              .read<PurchaseOrderFormCubit>()
                              .setProjectName(v),
                        ),
                      if (isUpdate) SizedBox(height: 24),
                      if (isUpdate)
                        TextfieldWidget(
                          disabled: isUpdate,
                          validator: AppValidators.required(
                            field: 'Project Code',
                          ),
                          hintText: 'Project Code',
                          title: 'Project Code',
                          initialValue: state.projectCode,
                          suffixIcon: PhosphorIconsBold.keyboard,
                          onChanged: (v) => context
                              .read<PurchaseOrderFormCubit>()
                              .setProjectCode(v),
                        ),
                      if (isUpdate) SizedBox(height: 24),
                      if (isUpdate)
                        TextfieldWidget(
                          disabled: isUpdate,
                          validator: AppValidators.required(
                            field: 'Customer Company',
                          ),
                          hintText: 'Customer Company',
                          title: 'Customer Company',
                          initialValue: state.customerCompany,
                          suffixIcon: PhosphorIconsBold.buildingOffice,
                          onChanged: (v) => context
                              .read<PurchaseOrderFormCubit>()
                              .setCustomerCompany(v),
                        ),
                      if (isUpdate) SizedBox(height: 24),
                      if (isUpdate)
                        TextfieldWidget(
                          disabled: isUpdate,
                          validator: AppValidators.required(
                            field: 'Customer Name',
                          ),
                          hintText: 'Customer Name',
                          title: 'Customer Name',
                          initialValue: state.customerName,
                          suffixIcon: PhosphorIconsBold.addressBookTabs,
                          onChanged: (v) => context
                              .read<PurchaseOrderFormCubit>()
                              .setCustomerName(v),
                        ),
                      if (isUpdate) SizedBox(height: 24),
                      if (isUpdate)
                        TextfieldWidget(
                          disabled: isUpdate,
                          validator: AppValidators.number(),
                          hintText: 'Customer Contact',
                          title: 'Customer Contact',
                          initialValue: state.customerContact,
                          suffixIcon: PhosphorIconsBold.phoneCall,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                          ],
                          onChanged: (v) => context
                              .read<PurchaseOrderFormCubit>()
                              .setCustomerContact(v),
                        ),
                      if (isUpdate) SizedBox(height: 24),
                      ProductCategorySelectionWidget(
                        disabled: isUpdate,
                        title: 'Product Category',
                        selected: state.productCategory?.title ?? '',
                        onPressed: (value) {
                          context
                              .read<PurchaseOrderFormCubit>()
                              .setProductCategory(value);
                          context.pop();
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<PurchaseOrderFormCubit>(),
                          ),
                        ],
                        icon: PhosphorIconsBold.archive,
                      ),
                      SizedBox(height: 24),
                      ProductSelectionWidget(
                        disabled: isUpdate,
                        title: 'Product Model',
                        categoryId: state.productCategory?.categoryId ?? '',
                        selected: state.productSelection?.productModel ?? '',
                        onPressed: (value) {
                          context
                              .read<PurchaseOrderFormCubit>()
                              .setProductSelection(value);
                          context.pop();
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<PurchaseOrderFormCubit>(),
                          ),
                        ],
                        icon: PhosphorIconsBold.washingMachine,
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        disabled: isUpdate,
                        validator: AppValidators.number(),
                        hintText: 'Quantity',
                        title: 'Quantity',
                        initialValue: state.quantity.toString(),
                        suffixIcon: PhosphorIconsBold.package,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (v) => context
                            .read<PurchaseOrderFormCubit>()
                            .setQuantity(int.parse(v)),
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
                              collection: collection,
                              document: document,
                              subCollection: 'Currency',
                              selected: state.currency,
                              icon: PhosphorIconsBold.creditCard,
                              onSelected: (value) {
                                context
                                    .read<PurchaseOrderFormCubit>()
                                    .setCurrency(value.title);
                                context.pop();
                              },
                              extraProviders: [
                                BlocProvider.value(
                                  value: context.read<PurchaseOrderFormCubit>(),
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
                                  .read<PurchaseOrderFormCubit>()
                                  .setPriceInt(int.parse(v)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      DatePickerWidget(
                        title: 'Bill of Ladding Date',
                        selected: state.blDate,
                        onChanged: (d) =>
                            context.read<PurchaseOrderFormCubit>().setBLDate(d),
                      ),
                      SizedBox(height: 24),
                      DatePickerWidget(
                        title: 'Arrival Date',
                        selected: state.arrivalDate,
                        onChanged: (d) => context
                            .read<PurchaseOrderFormCubit>()
                            .setArrivalDate(d),
                      ),
                      SizedBox(height: 50),
                      ActionButtonWidget(
                        onPressed: () {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) return;

                          context.read<ActionButtonCubit>().execute(
                            usecase: isUpdate
                                ? purchaseOrder!.type.title != 'Purchase Order'
                                      ? FillPurchaseOrderUseCase()
                                      : UpdatePurchaseOrderUseCase()
                                : AddPurchaseOrderUseCase(),
                            params: context
                                .read<PurchaseOrderFormCubit>()
                                .state,
                          );
                        },
                        title: isUpdate
                            ? purchaseOrder!.type.title != 'Purchase Order'
                                  ? 'Fill Data'
                                  : 'Update Purchase Order'
                            : 'Add New Purchase Order',
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
