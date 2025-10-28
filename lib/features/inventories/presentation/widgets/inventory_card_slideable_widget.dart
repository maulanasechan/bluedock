import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/features/inventories/domain/usecases/delete_inventory_usecase.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_cubit.dart';
import 'package:bluedock/features/inventories/presentation/widgets/inventory_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class InventoryCardSlidableWidget extends StatelessWidget {
  final InventoryEntity inventory;
  const InventoryCardSlidableWidget({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        isSlideable: inventory.arrivalDate != null ? false : true,

        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.inventoryForm,
            extra: inventory,
          );
          if (changed == true && context.mounted) {
            context.read<InventoryDisplayCubit>().displayInitial();
          }
        },
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove ${inventory.stockName}',
            subtitle: "Are you sure to remove ${inventory.stockName}?",

            yesButton: 'Remove',

            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              actionCubit.execute(
                usecase: DeleteInventoryUseCase(),
                params: inventory,
              );
              final ok = await waitActionDone(actionCubit);
              if (ok && context.mounted) context.pop(true);
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.inventorySuccess,
              extra: {
                'title': '${inventory.stockName} has been removed',
                'image': AppImages.appProductDeleted,
              },
            );

            if (change == true && context.mounted) {
              context.read<InventoryDisplayCubit>().displayInitial();
            }
          }
        },
        deleteParams: inventory.inventoryId,
        child: InventoryCardWidget(inventory: inventory),
      ),
    );
  }
}
