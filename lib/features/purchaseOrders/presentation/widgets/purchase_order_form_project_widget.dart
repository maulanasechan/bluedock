import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/selection/project_selection_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PurchaseOrderFormProjectWidget extends StatelessWidget {
  final PurchaseOrderFormReq state;
  const PurchaseOrderFormProjectWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PurchaseOrderFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSelectionWidget(
          status: 'Inactive',
          title: 'Project Reference',
          selected: state.project?.projectName ?? '',
          onPressed: (v) {
            cubit
              ..setProject(v)
              ..setQuantityFromTextList(v.quantity.toString());
            context.pop();
          },
          extraProviders: [BlocProvider.value(value: cubit)],
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
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => cubit.setSellerContact(v),
        ),
        SizedBox(height: 24),
        TextfieldWidget(
          key: ValueKey(
            '${state.quantity.length}:${state.quantity.isNotEmpty ? state.quantity[0] : 0}',
          ),
          validator: AppValidators.number(),
          hintText: 'Quantity',
          title: 'Quantity',
          initialValue: state.quantity.isNotEmpty
              ? state.quantity[0].toString()
              : '',
          suffixIcon: PhosphorIconsBold.package,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => cubit.setQuantityFromTextList(v),
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
