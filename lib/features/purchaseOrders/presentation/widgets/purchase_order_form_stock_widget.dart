import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/selection/inventory_selection_widget.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/selection/product_category_selection_widget.dart';
import 'package:bluedock/common/widgets/selection/product_selection_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PurchaseOrderFormStockWidget extends StatelessWidget {
  final PurchaseOrderFormReq state;
  const PurchaseOrderFormStockWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PurchaseOrderFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        TextfieldWidget(
          validator: AppValidators.required(field: 'Purchase Order Name'),
          hintText: 'Purchase Order Name',
          title: 'Purchase Order Name',
          initialValue: state.poName,
          suffixIcon: PhosphorIconsBold.articleNyTimes,
          onChanged: (v) => cubit.setPOName(v),
        ),
        SizedBox(height: 24),
        TextfieldWidget(
          validator: AppValidators.required(field: 'Customer Company'),
          hintText: 'Seller Company',
          title: 'Seller Company',
          initialValue: state.sellerCompany,
          suffixIcon: PhosphorIconsBold.buildingOffice,
          onChanged: (v) => cubit.setSellerCompany(v),
        ),
        SizedBox(height: 24),
        TextfieldWidget(
          validator: AppValidators.required(field: 'Customer Name'),
          hintText: 'Seller Name',
          title: 'Seller Name',
          initialValue: state.sellerName,
          suffixIcon: PhosphorIconsBold.addressBookTabs,
          onChanged: (v) => cubit.setSellerName(v),
        ),
        SizedBox(height: 24),
        TextfieldWidget(
          validator: AppValidators.number(),
          hintText: 'Seller Contact',
          title: 'Seller Contact',
          initialValue: state.sellerContact,
          suffixIcon: PhosphorIconsBold.phoneCall,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
          onChanged: (v) => cubit.setSellerContact(v),
        ),
        SizedBox(height: 24),
        ProductCategorySelectionWidget(
          title: 'Product Category',
          selected: state.productCategory?.title ?? '',
          onPressed: (value) {
            cubit.setProductCategory(value);
            context.pop();
          },
          extraProviders: [BlocProvider.value(value: cubit)],
          icon: PhosphorIconsBold.archive,
        ),
        SizedBox(height: 24),
        ProductSelectionWidget(
          title: 'Product Model',
          categoryId: state.productCategory?.categoryId ?? '',
          selected: state.productSelection?.productModel ?? '',
          onPressed: (value) {
            cubit.setProductSelection(value);
            context.pop();
          },
          extraProviders: [BlocProvider.value(value: cubit)],
          icon: PhosphorIconsBold.washingMachine,
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: 'Component',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            Row(
              children: [
                IconButtonWidget(
                  width: 30,
                  icon: PhosphorIconsBold.minusCircle,
                  iconSize: 28,
                  iconColor: AppColors.blue,
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
                  iconColor: AppColors.blue,
                  onPressed: () {
                    cubit.addComponent();
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: state.componentLength,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final selectedInv = (state.listComponent.length > index)
                ? state.listComponent[index]
                : null;

            final unitText = (state.quantity.length > index)
                ? state.quantity[index].toString()
                : '';

            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: InventorySelectionWidget(
                    listComponent: state.listComponent,
                    withoutIcon: true,
                    index: index + 1,
                    selected: selectedInv,
                    onPressed: (value) {
                      cubit.setComponentAt(index, value);
                    },
                    categoryId: state.productCategory?.categoryId ?? '',
                    productId: state.productSelection?.productId ?? '',
                    extraProviders: [BlocProvider.value(value: cubit)],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 65,
                  child: TextfieldWidget(
                    validator: AppValidators.number(),
                    hintText: 'Unit',
                    initialValue: unitText,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) {
                      cubit.updateQuantityAt(index, int.tryParse(v) ?? 0);
                    },
                  ),
                ),
                if (state.componentLength > 1) const SizedBox(width: 8),
                if (state.componentLength > 1)
                  GestureDetector(
                    onTap: state.componentLength == 1
                        ? null
                        : () => cubit.removeComponentAt(index),
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
                extraProviders: [BlocProvider.value(value: cubit)],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextfieldWidget(
                validator: AppValidators.number(),
                hintText: 'Price',
                initialValue: state.price == null ? '' : state.price.toString(),
                suffixIcon: PhosphorIconsBold.moneyWavy,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (v) => cubit.setPriceInt(int.parse(v)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
