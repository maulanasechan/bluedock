import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/dateTimePicker/date_picker_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/features/orderDeliveries/data/models/order_delivery_form_req.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrderDeliveryFormOutboundWidget extends StatelessWidget {
  final OrderDeliveryFormReq state;
  const OrderDeliveryFormOutboundWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderDeliveryFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextfieldWidget(
          validator: AppValidators.required(field: 'Bill of Ladding Number'),
          hintText: 'Bill of Ladding Number',
          title: 'Bill of Ladding Number',
          initialValue: state.shipperCompany,
          suffixIcon: PhosphorIconsBold.articleNyTimes,
          onChanged: (v) => cubit.setShipperCompany(v),
        ),
        SizedBox(height: 24),
        DatePickerWidget(
          title: 'Bill of Ladding Date',
          selected: state.deliveryDate,
          onChanged: (v) => cubit.setDeliveryDate(v),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
