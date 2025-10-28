import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOrderButton extends StatelessWidget {
  final String title;
  final String selectedTitle;
  final bool isUpdate;

  const PurchaseOrderButton({
    super.key,
    required this.title,
    required this.selectedTitle,
    required this.isUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, TypeCategorySelectionEntity> typeMap = {
      "Project": TypeCategorySelectionEntity(
        selectionId: 'SnSu62diYMdF0FzOItzJ',
        title: 'Project',
        image: 'assets/icons/project.png',
        color: '0F6CBB', // asumsi format String hex yang memang dipakai entity
      ),
      "Aftersales": TypeCategorySelectionEntity(
        selectionId: 'ROlsI0IpETBa2fXP8aI5',
        title: 'Aftersales',
        image: 'assets/icons/aftersales.png',
        color: '9E2A00',
      ),
      "Stock": TypeCategorySelectionEntity(
        selectionId: 'lA1UeFRAk3dwN4HqmAzP',
        title: 'Stock',
        image: 'assets/icons/purchaseOrder.png',
        color: '7A869D',
      ),
    };

    final bool isSelected = selectedTitle == title;

    return Expanded(
      child: ButtonWidget(
        onPressed: () {
          if (isUpdate) return;
          if (isSelected) return;
          final value = typeMap[title];
          if (value == null) return; // guard kalau title tidak terdaftar
          context.read<PurchaseOrderFormCubit>().setType(value);
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
