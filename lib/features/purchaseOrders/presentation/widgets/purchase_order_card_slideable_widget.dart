import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/delete_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_cubit.dart';
import 'package:bluedock/features/purchaseOrders/presentation/widgets/purchase_order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PurchaseOrderCardSlideableWidget extends StatelessWidget {
  final PurchaseOrderEntity po;
  const PurchaseOrderCardSlideableWidget({super.key, required this.po});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        isSlideable: po.status == 'Inactive',
        isUpdated: po.status == 'Inactive',
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.formPurchaseOrder,
            extra: po,
          );
          if (changed == true && context.mounted) {
            context.read<PurchaseOrderDisplayCubit>().displayInitial();
          }
        },
        extentRatio: po.status == 'Inactive' ? 0.4 : 0.2,
        isDeleted: po.status == 'Inactive',
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove ${po.poName}',
            subtitle: "Are you sure to remove this ${po.poName}?",
            yesButton: 'Remove',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              actionCubit.execute(
                usecase: DeletePurchaseOrderUseCase(),
                params: po.purchaseOrderId,
              );
              final ok = await waitActionDone(actionCubit);
              if (ok && context.mounted) context.pop(true);
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.purchaseOrderSuccess,
              extra: {
                'title': 'Purchase order has been removed',
                'image': AppImages.appTaskDeleted,
              },
            );
            if (change == true && context.mounted) {
              context.read<PurchaseOrderDisplayCubit>().displayInitial();
            }
          }
        },
        deleteParams: po.purchaseOrderId,
        child: PurchaseOrderCardWidget(po: po),
      ),
    );
  }
}
