import 'package:bluedock/common/bloc/productSection/product_section_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/selection/product_category_selection_widget.dart';
import 'package:bluedock/common/widgets/selection/product_selection_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/search_textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_cubit.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_state.dart';
import 'package:bluedock/features/inventories/presentation/widgets/inventory_card_slideable_widget.dart';
import 'package:bluedock/features/project/presentation/widgets/project_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ManageInventoryPage extends StatelessWidget {
  const ManageInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryDisplayCubit()..displayInitial()),
        BlocProvider(create: (_) => ActionButtonCubit()),
        BlocProvider(create: (_) => ProductSectionCubit()),
      ],
      child: Builder(
        builder: (ctx) {
          final selectedCategory = ctx
              .watch<InventoryDisplayCubit>()
              .currentCategory;
          final selectedCategoryId = ctx
              .watch<InventoryDisplayCubit>()
              .currentCategoryId;
          final selectedModel = ctx.watch<InventoryDisplayCubit>().currentModel;
          return GradientScaffoldWidget(
            hideBack: false,
            appbarTitle: 'Manage Inventory',
            appbarAction: IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsBold.package,
              iconSize: 24,
              onPressed: () async {
                final changed = await ctx.pushNamed(AppRoutes.inventoryForm);
                if (changed == true && ctx.mounted) {
                  ctx.read<InventoryDisplayCubit>().displayInitial();
                }
              },
            ),
            body: Column(
              children: [
                SearchTextfieldWidget(
                  onChanged: (value) {
                    if (value.isEmpty) {
                      ctx.read<InventoryDisplayCubit>().displayInitial();
                    } else {
                      ctx.read<InventoryDisplayCubit>().setKeyword(value);
                    }
                  },
                ),
                SizedBox(height: 12),
                ProductCategorySelectionWidget(
                  borderRadius: 50,
                  selected: selectedCategory,
                  onPressed: (value) {
                    ctx.read<InventoryDisplayCubit>().setCategory(value);
                    ctx.pop();
                  },
                  height: 50,
                  extraProviders: [
                    BlocProvider.value(
                      value: ctx.read<InventoryDisplayCubit>(),
                    ),
                  ],
                  icon: PhosphorIconsBold.archive,
                ),
                SizedBox(height: 12),
                ProductSelectionWidget(
                  categoryId: selectedCategoryId,
                  selected: selectedModel,
                  height: 50,
                  borderRadius: 50,
                  onPressed: (value) {
                    ctx.read<InventoryDisplayCubit>().setModel(value);
                    ctx.pop();
                  },
                  extraProviders: [
                    BlocProvider.value(
                      value: ctx.read<InventoryDisplayCubit>(),
                    ),
                  ],
                  icon: PhosphorIconsBold.washingMachine,
                ),
                SizedBox(height: 24),
                Expanded(
                  child:
                      BlocBuilder<InventoryDisplayCubit, InventoryDisplayState>(
                        builder: (context, state) {
                          if (state is InventoryDisplayLoading) {
                            return ProjectLoadingWidget();
                          }
                          if (state is InventoryDisplayFetched) {
                            if (state.listInventory.isEmpty) {
                              return Center(
                                child: TextWidget(
                                  text: "There isn't any inventory.",
                                ),
                              );
                            } else {
                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final inventory = state.listInventory[index];

                                  return InventoryCardSlidableWidget(
                                    inventory: inventory,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 12);
                                },
                                itemCount: state.listInventory.length,
                              );
                            }
                          }
                          return SizedBox();
                        },
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
