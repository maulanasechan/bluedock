import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/widgets/dropdown_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/project/data/models/project_form_req.dart';
import 'package:bluedock/features/project/data/models/selection/product_selection_req.dart';
import 'package:bluedock/features/project/domain/entities/selection/product_selection_entity.dart';
import 'package:bluedock/features/project/presentation/bloc/project/project_form_cubit.dart';
import 'package:bluedock/features/project/presentation/bloc/selection/project_selection_display_cubit.dart';
import 'package:bluedock/features/project/presentation/bloc/selection/project_selection_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProductSelectionWidget extends StatelessWidget {
  final String title;
  final String selected;
  final String categoryId; // wajib non-null
  final void Function(ProductSelectionEntity) onPressed;
  final PhosphorIconData? icon;
  final double heightButton;

  const ProductSelectionWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onPressed,
    required this.categoryId,
    this.icon,
    this.heightButton = 50,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownWidget(
      icon: icon,
      title: title,
      state: selected.isEmpty ? title : selected,
      validator: (_) => selected.isEmpty ? '$title is required.' : null,
      onTap: () {
        if (categoryId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pilih Product Category dulu')),
          );
          return;
        }

        BottomModalWidget.display(
          context,
          height: MediaQuery.of(context).size.height,
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<ProjectFormCubit>()),
              BlocProvider.value(
                value: context.read<ProjectSelectionDisplayCubit>()
                  ..displayProductSelection(
                    ProductSelectionReq(categoryId: categoryId, keyword: ''),
                  ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Choose one $title:',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  const SizedBox(height: 24),
                  TextfieldWidget(
                    prefixIcon: PhosphorIconsBold.magnifyingGlass,
                    borderRadius: 60,
                    iconColor: AppColors.darkBlue,
                    hintText: 'Search',
                    onChanged: (value) {
                      context
                          .read<ProjectSelectionDisplayCubit>()
                          .displayProductSelection(
                            ProductSelectionReq(
                              categoryId: categoryId,
                              keyword: value,
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child:
                        BlocBuilder<
                          ProjectSelectionDisplayCubit,
                          ProjectSelectionDisplayState
                        >(
                          builder: (context, state) {
                            if (state is ProjectSelectionDisplayLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is ProjectSelectionDisplayFailure) {
                              return Center(child: Text(state.message));
                            }
                            if (state is ProductSelectionDisplayFetched) {
                              final listSelection = state.listSelection;
                              if (listSelection.isEmpty) {
                                return const Center(
                                  child: Text('No product found'),
                                );
                              }
                              return BlocBuilder<
                                ProjectFormCubit,
                                ProjectFormReq
                              >(
                                builder: (context, formState) {
                                  return ListView.separated(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    itemCount: listSelection.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 20),
                                    itemBuilder: (context, index) {
                                      final value = listSelection[index];
                                      final isSelected =
                                          selected == value.productModel;
                                      return ButtonWidget(
                                        height: 60,
                                        background: isSelected
                                            ? AppColors.blue
                                            : AppColors.white,
                                        title: value.productModel,
                                        onPressed: () => onPressed(value),
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Image.asset(
                                                  value.image,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextWidget(
                                                      text: value.productModel,
                                                      color:
                                                          selected ==
                                                              value.productModel
                                                          ? AppColors.white
                                                          : AppColors.darkBlue,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    TextWidget(
                                                      text:
                                                          "${value.quantity.toInt()} Unit",
                                                      overflow:
                                                          TextOverflow.fade,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          selected ==
                                                              value.productModel
                                                          ? AppColors.white
                                                          : AppColors.orange,
                                                      fontSize: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
