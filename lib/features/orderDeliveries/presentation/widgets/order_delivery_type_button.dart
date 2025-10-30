import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDeliveryTypeButton extends StatelessWidget {
  final String title;
  final String selectedTitle;
  final bool isUpdate;

  const OrderDeliveryTypeButton({
    super.key,
    required this.title,
    required this.selectedTitle,
    required this.isUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedTitle == title;

    return Expanded(
      child: ButtonWidget(
        onPressed: () {
          if (isUpdate) return;
          if (isSelected) return;
          final value = title;
          context.read<OrderDeliveryFormCubit>().setType(value);
        },
        title: title, // tidak hardcode lagi
        fontSize: 14,
        height: 40,
        background: isSelected ? AppColors.blue : AppColors.white,
        fontColor: isSelected ? AppColors.white : AppColors.darkBlue,
      ),
    );
  }
}
