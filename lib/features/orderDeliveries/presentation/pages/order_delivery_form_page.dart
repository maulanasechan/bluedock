import 'package:bluedock/common/bloc/productSection/product_section_cubit.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/dateTimePicker/date_picker_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/selection/inventory_selection_widget.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/selection/purchase_order_selection_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_cubit.dart';
import 'package:bluedock/features/orderDeliveries/data/models/order_delivery_form_req.dart';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:bluedock/features/orderDeliveries/domain/usecases/create_order_delivery_usecase.dart';
import 'package:bluedock/features/orderDeliveries/domain/usecases/update_order_delivery_usecase.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_form_cubit.dart';
import 'package:bluedock/features/orderDeliveries/presentation/widgets/order_delivery_form_inbound_widget.dart';
import 'package:bluedock/features/orderDeliveries/presentation/widgets/order_delivery_form_outbound_widget.dart';
import 'package:bluedock/features/orderDeliveries/presentation/widgets/order_delivery_type_button.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrderDeliveryFormPage extends StatelessWidget {
  final OrderDeliveryEntity? orderDelivery;
  OrderDeliveryFormPage({super.key, this.orderDelivery});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = orderDelivery != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = OrderDeliveryFormCubit();
            if (isUpdate) c.hydrateFromEntity(orderDelivery!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ProductSectionCubit()),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
        BlocProvider(create: (context) => InventoryDisplayCubit()),
        BlocProvider(create: (context) => PurchaseOrderDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate
            ? 'Update Order Delivery'
            : 'Create Order Delivery',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) async {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final changed = await context.pushNamed(
                AppRoutes.orderDeliverySuccess,
                extra: {
                  'title': isUpdate
                      ? 'Order delivery has been updated'
                      : 'New order delivery has been added',
                },
              );
              if (changed == true && context.mounted) {
                context.pop(true);
              }
            }
          },
          child: BlocBuilder<OrderDeliveryFormCubit, OrderDeliveryFormReq>(
            builder: (context, state) {
              final cubit = context.read<OrderDeliveryFormCubit>();
              final po = state.purchaseOrder;
              final canShowModel =
                  po != null &&
                  po.productCategory != null &&
                  po.productSelection != null;
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        OrderDeliveryTypeButton(
                          isUpdate: isUpdate,
                          title: 'Inbound',
                          selectedTitle: state.type,
                        ),
                        SizedBox(width: 14),
                        OrderDeliveryTypeButton(
                          isUpdate: isUpdate,
                          title: 'Outbound',
                          selectedTitle: state.type,
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PurchaseOrderSelectionWidget(
                              status: 'Active',
                              title: 'Purchase Order Reference',
                              selected: state.purchaseOrder?.poName ?? '',
                              onPressed: (v) {
                                cubit
                                  ..setPurchaseOrder(v)
                                  ..setListComponent(v.listComponent)
                                  ..setQuantityList(v.quantity)
                                  ..setComponentLength(v.listComponent.length);
                                context.pop();
                              },
                              extraProviders: [
                                BlocProvider.value(value: cubit),
                              ],
                            ),
                            if (canShowModel) SizedBox(height: 24),
                            if (canShowModel)
                              TextfieldWidget(
                                title: 'Product Model',
                                initialValue:
                                    '${state.purchaseOrder!.productCategory!.title} - ${state.purchaseOrder!.productSelection!.productModel}',
                                suffixIcon: PhosphorIconsBold.washingMachine,
                                disabled: true,
                                onChanged: (v) => cubit.setShipperCompany(v),
                              ),
                            if (state.listComponent.isNotEmpty)
                              SizedBox(height: 24),
                            if (state.listComponent.isNotEmpty)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                    text: 'List Component',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Row(
                                    children: [
                                      IconButtonWidget(
                                        width: 30,
                                        icon: PhosphorIconsBold.minusCircle,
                                        iconSize: 28,
                                        iconColor: state.componentLength == 1
                                            ? AppColors.grey
                                            : AppColors.blue,
                                        onPressed: state.componentLength == 1
                                            ? () {}
                                            : () {
                                                cubit.removeLastComponent();
                                              },
                                      ),
                                      SizedBox(width: 12),
                                      TextWidget(
                                        text: state.componentLength.toString(),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      SizedBox(width: 12),
                                      IconButtonWidget(
                                        width: 30,
                                        icon: PhosphorIconsBold.plusCircle,
                                        iconSize: 28,
                                        iconColor:
                                            state.componentLength ==
                                                state
                                                    .purchaseOrder!
                                                    .listComponent
                                                    .length
                                            ? AppColors.grey
                                            : AppColors.blue,
                                        onPressed:
                                            state.componentLength ==
                                                state
                                                    .purchaseOrder!
                                                    .listComponent
                                                    .length
                                            ? () {}
                                            : () {
                                                cubit.addComponent();
                                              },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            if (canShowModel && state.listComponent.isEmpty)
                              SizedBox(height: 24),
                            if (canShowModel && state.listComponent.isEmpty)
                              TextfieldWidget(
                                disabled: true,
                                title: 'Quantity',
                                validator: AppValidators.number(),
                                hintText: 'Unit',
                                initialValue: state.purchaseOrder?.quantity[0]
                                    .toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (v) {},
                              ),
                            if (state.listComponent.isNotEmpty)
                              SizedBox(height: 24),
                            if (state.listComponent.isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: state.componentLength,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final selectedInv =
                                      (state.listComponent.length > index)
                                      ? state.listComponent[index]
                                      : null;

                                  final unitText =
                                      (state.listQuantity.length > index)
                                      ? state.listQuantity[index].toString()
                                      : '';

                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: InventorySelectionWidget(
                                          disabled: true,
                                          listComponent: state.listComponent,
                                          withoutIcon: true,
                                          index: index + 1,
                                          selected: selectedInv,
                                          onPressed: (value) {
                                            cubit.setComponentAt(index, value);
                                          },
                                          categoryId: '',
                                          productId: '',
                                          extraProviders: [
                                            BlocProvider.value(value: cubit),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 65,
                                        child: TextfieldWidget(
                                          key: ValueKey(
                                            'qty_${index}_$unitText',
                                          ),
                                          disabled: true,
                                          validator: AppValidators.number(),
                                          hintText: 'Unit',
                                          initialValue: unitText,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (v) {
                                            cubit.updateQuantityAt(
                                              index,
                                              int.tryParse(v) ?? 0,
                                            );
                                          },
                                        ),
                                      ),
                                      if (state.componentLength > 1)
                                        const SizedBox(width: 8),
                                      if (state.componentLength > 1)
                                        GestureDetector(
                                          onTap: state.componentLength == 1
                                              ? null
                                              : () => cubit.removeComponentAt(
                                                  index,
                                                ),
                                          child: CardContainerWidget(
                                            margin: EdgeInsets.zero,
                                            width: 55,
                                            height: 55,
                                            child: PhosphorIcon(
                                              PhosphorIconsBold.trash,
                                              color: AppColors.blue,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            SizedBox(height: 24),
                            state.type == 'Inbound'
                                ? OrderDeliveryFormInboundWidget(state: state)
                                : OrderDeliveryFormOutboundWidget(state: state),
                            DatePickerWidget(
                              title: 'Estimated Arrival Date',
                              selected: state.estimatedDate,
                              onChanged: (v) => cubit.setEstimatedDate(v),
                            ),
                            SizedBox(height: 24),
                            TextfieldWidget(
                              validator: AppValidators.required(
                                field: 'Customer Company',
                              ),
                              hintText: 'Shipper Company',
                              title: 'Shipper Company',
                              initialValue: state.shipperCompany,
                              suffixIcon: PhosphorIconsBold.buildingOffice,
                              onChanged: (v) => cubit.setShipperCompany(v),
                            ),
                            SizedBox(height: 24),
                            TextfieldWidget(
                              validator: AppValidators.number(),
                              hintText: 'Shipper Contact',
                              title: 'Shipper Contact',
                              initialValue: state.shipperContact,
                              suffixIcon: PhosphorIconsBold.phoneCall,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (v) => cubit.setShipperContact(v),
                            ),
                            SizedBox(height: 24),
                            TextfieldWidget(
                              validator: AppValidators.required(
                                field: 'Discharge Address',
                              ),
                              hintText: 'Discharge Address',
                              title: 'Discharge Address',
                              initialValue: state.dischargeLocation,
                              maxLines: 3,
                              suffixIcon: PhosphorIconsBold.mapPinArea,
                              onChanged: (v) => cubit.setDischargeLocation(v),
                            ),
                            SizedBox(height: 24),
                            TextfieldWidget(
                              validator: AppValidators.required(
                                field: 'Delivery Location',
                              ),
                              hintText: 'Delivery Location',
                              title: 'Delivery Location',
                              initialValue: state.arrivalLocation,
                              suffixIcon: PhosphorIconsBold.mapPinLine,
                              maxLines: 3,
                              onChanged: (v) => cubit.setArrivalLocation(v),
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
                                      cubit.setCurrency(value.title);
                                      context.pop();
                                    },
                                    extraProviders: [
                                      BlocProvider.value(value: cubit),
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
                                    onChanged: (v) =>
                                        cubit.setPriceInt(int.parse(v)),
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
                                      ? UpdateOrderDeliveryUseCase()
                                      : CreateOrderDeliveryUseCase(),
                                  params: cubit.state,
                                );
                              },
                              title: isUpdate
                                  ? 'Update Order Delivery'
                                  : 'Create Order Delivery',
                              fontSize: 16,
                            ),
                            SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
