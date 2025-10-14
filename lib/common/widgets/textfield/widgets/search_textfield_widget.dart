import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/custom_textfield_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SearchTextfieldWidget extends StatelessWidget {
  final void Function(String) onChanged;
  final bool withFilter;
  final List<String> listFilter;
  final String selected;
  final void Function(String)? onSelected;
  final Color? selectedColor;

  const SearchTextfieldWidget({
    super.key,
    required this.onChanged,
    this.withFilter = false,
    this.listFilter = const <String>[],
    this.selected = '',
    this.onSelected,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: CustomTextfieldWidget(
              prefixIcon: PhosphorIconsBold.magnifyingGlass,
              borderRadius: 60,
              iconColor: AppColors.darkBlue,
              hintText: 'Search',
              onChanged: onChanged,
            ),
          ),
        ),
        if (withFilter) SizedBox(width: 10),
        if (withFilter)
          IconButtonWidget(
            width: 50,
            icon: PhosphorIconsBold.faders,
            iconColor: selected != 'All' ? AppColors.white : AppColors.darkBlue,
            backgroundColor: selected != 'All'
                ? selectedColor ?? AppColors.orange
                : AppColors.white,
            iconSize: 25,
            onPressed: () {
              BottomModalWidget.display(
                context,
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Choose one filter:',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final value = listFilter[index];
                            return ButtonWidget(
                              background: selected == value
                                  ? AppColors.blue
                                  : AppColors.white,
                              onPressed: () {
                                onSelected?.call(value);
                                context.pop(true);
                              },
                              title: value,
                              fontColor: selected == value
                                  ? AppColors.white
                                  : AppColors.darkBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemCount: listFilter.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
