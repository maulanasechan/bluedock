import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/domain/entities/selection_entity.dart';
import 'package:flutter/material.dart';

class ListSelectionButtonWidget extends StatelessWidget {
  final List<SelectionEntity> listSelection;
  final String selected;
  final void Function(SelectionEntity) onSelected;
  const ListSelectionButtonWidget({
    super.key,
    required this.listSelection,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 3),
      itemBuilder: (context, index) {
        final value = listSelection[index];
        return ButtonWidget(
          background: selected == value.title
              ? AppColors.blue
              : AppColors.white,
          onPressed: () => onSelected(value),
          title: value.title,
          fontColor: selected == value.title
              ? AppColors.white
              : AppColors.darkBlue,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: listSelection.length,
    );
  }
}
