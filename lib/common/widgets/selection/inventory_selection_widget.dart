import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/dropdown_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/inventories/data/models/search_inventory_req.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_cubit.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class InventorySelectionWidget extends StatelessWidget {
  final String? title;
  final InventoryEntity? selected; // ← nullable
  final void Function(InventoryEntity) onPressed;
  final PhosphorIconData? icon;
  final List<BlocProvider> extraProviders;
  final String categoryId;
  final String productId;
  final int? index;
  final bool? withoutIcon;
  final List<InventoryEntity>? listComponent;
  final bool disabled;

  const InventorySelectionWidget({
    super.key,
    this.title,
    this.index,
    this.listComponent,
    required this.selected,
    required this.onPressed,
    required this.categoryId,
    required this.productId,
    this.icon,
    this.extraProviders = const <BlocProvider>[],
    this.withoutIcon = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownWidget(
      disabled: disabled,
      withoutIcon: withoutIcon,
      icon: icon,
      title: title,
      state: selected?.stockName ?? 'Components',
      validator: (_) => (selected == null)
          ? '${index != null ? 'Component $index' : 'Component'} is required.'
          : null,
      onTap: () {
        if (categoryId.isEmpty || productId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'You need to choose product category and product model first.',
              ),
            ),
          );
          return;
        }

        final invCubit = context.read<InventoryDisplayCubit>();
        invCubit.displayInventory(
          params: SearchInventoryReq(category: categoryId, model: productId),
        );

        BottomModalWidget.display(
          context,
          height: MediaQuery.of(context).size.height,
          MultiBlocProvider(
            providers: [
              ...extraProviders,
              BlocProvider.value(value: invCubit),
            ],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text:
                        'Choose one ${index != null ? 'Component $index' : 'Component'} :',
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
                      invCubit.displayInventory(
                        params: SearchInventoryReq(
                          category: categoryId,
                          model: productId,
                          keyword: value,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child:
                        BlocBuilder<
                          InventoryDisplayCubit,
                          InventoryDisplayState
                        >(
                          builder: (context, state) {
                            if (state is InventoryDisplayLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is InventoryDisplayFailure) {
                              return Center(child: Text(state.message));
                            }
                            if (state is InventoryDisplayFetched) {
                              final all = state.listInventory;

                              List<InventoryEntity> filtered;

                              if (listComponent == null ||
                                  listComponent!.isEmpty) {
                                filtered = all;
                              } else {
                                final chosenIds = listComponent!
                                    .map((e) => e.inventoryId)
                                    .where((id) => id.isNotEmpty)
                                    .toSet();

                                if (selected != null) {
                                  chosenIds.remove(selected!.inventoryId);
                                }

                                filtered = all
                                    .where(
                                      (e) => !chosenIds.contains(e.inventoryId),
                                    )
                                    .toList();
                              }

                              if (filtered.isEmpty) {
                                return const Center(
                                  child: Text('Inventory not found'),
                                );
                              }

                              return ListView.separated(
                                padding: const EdgeInsets.only(bottom: 3),
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  final value = filtered[index];
                                  final bool isSelected =
                                      selected?.inventoryId ==
                                      value.inventoryId;

                                  return ButtonWidget(
                                    background: isSelected
                                        ? AppColors.blue
                                        : AppColors.white,
                                    onPressed: () {
                                      onPressed(value);
                                      Navigator.of(
                                        context,
                                      ).maybePop(); // tutup modal
                                    },
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextWidget(
                                              text: value.stockName,
                                              color: isSelected
                                                  ? AppColors.white
                                                  : AppColors.darkBlue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          TextWidget(
                                            text: '${value.quantity} Unit',
                                            color: isSelected
                                                ? AppColors.white
                                                : AppColors.orange,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                    ),
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
