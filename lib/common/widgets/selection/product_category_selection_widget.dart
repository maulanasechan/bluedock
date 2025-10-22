import 'package:bluedock/common/bloc/productSection/product_section_cubit.dart';
import 'package:bluedock/common/bloc/productSection/product_section_state.dart';
import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/dropdown_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProductCategorySelectionWidget extends StatelessWidget {
  final String title;
  final String selected;
  final void Function(ProductCategoryEntity) onPressed;
  final PhosphorIconData? icon;
  final double? heightButton;
  final List<BlocProvider> extraProviders;
  final bool disabled;
  const ProductCategorySelectionWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onPressed,
    this.icon,
    this.heightButton = 50,
    required this.extraProviders,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownWidget(
      icon: icon,
      disabled: disabled,
      title: title,
      state: selected == '' ? title : selected,
      validator: (_) => selected == '' ? '$title is required.' : null,
      onTap: () {
        BottomModalWidget.display(
          context,
          MultiBlocProvider(
            providers: [
              ...extraProviders,
              BlocProvider.value(
                value: context.read<ProductSectionCubit>()
                  ..displayProductCategories(),
              ),
            ],
            child: BlocBuilder<ProductSectionCubit, ProductSectionState>(
              builder: (context, state) {
                if (state is ProductSectionLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is ProductSectionFailure) {
                  return Center(child: Text(state.message));
                }
                if (state is ProductCategoryFetched) {
                  final listSelection = state.productCategory;
                  return Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: 'Choose one $title :',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 3),
                            itemBuilder: (context, index) {
                              final value = listSelection[index];
                              return ButtonWidget(
                                height: heightButton,
                                background: selected == value.title
                                    ? AppColors.blue
                                    : AppColors.white,
                                onPressed: () => onPressed(value),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: value.title,
                                        color: selected == value.title
                                            ? AppColors.white
                                            : AppColors.darkBlue,
                                        overflow: TextOverflow.fade,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      TextWidget(
                                        text:
                                            "${value.totalProduct.toInt()} Product",
                                        overflow: TextOverflow.fade,
                                        fontWeight: FontWeight.w500,
                                        color: selected == value.title
                                            ? AppColors.white
                                            : AppColors.orange,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                            itemCount: listSelection.length,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ),
        );
      },
    );
  }
}
