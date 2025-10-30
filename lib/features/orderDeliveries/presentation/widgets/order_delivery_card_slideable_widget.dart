import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/slideAction/slide_action_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:bluedock/features/orderDeliveries/domain/usecases/complete_order_delivery_usecase.dart';
import 'package:bluedock/features/orderDeliveries/domain/usecases/delete_order_delivery_usecase.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_display_cubit.dart';
import 'package:bluedock/features/orderDeliveries/presentation/widgets/order_delivery_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrderDeliveryCardSlideableWidget extends StatelessWidget {
  final OrderDeliveryEntity od;
  const OrderDeliveryCardSlideableWidget({super.key, required this.od});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        isSlideable: od.status == 'Processed',
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.orderDeliveryForm,
            extra: od,
          );
          if (changed == true && context.mounted) {
            context.read<OrderDeliveryDisplayCubit>().displayInitial();
          }
        },
        extentRatio: 0.6,
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove ${od.purchaseOrder?.poName}',
            subtitle:
                "Are you sure to remove this ${od.purchaseOrder?.poName}?",
            yesButton: 'Remove',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              actionCubit.execute(
                usecase: DeleteOrderDeliveryUseCase(),
                params: od,
              );
              final ok = await waitActionDone(actionCubit);
              if (ok && context.mounted) context.pop(true);
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.orderDeliverySuccess,
              extra: {
                'title': 'Order Delivery has been removed',
                'image': AppImages.appTaskDeleted,
              },
            );
            if (change == true && context.mounted) {
              context.read<OrderDeliveryDisplayCubit>().displayInitial();
            }
          }
        },
        deleteParams: od.deliveryOrderId,
        extraActions: [
          SlideActionWidget(
            onTap: () async {
              final actionCubit = context.read<ActionButtonCubit>();
              final changed = await CenterModalWidget.display(
                context: context,
                title: 'Complete Delivery',
                subtitle:
                    "Are you sure this ${od.purchaseOrder?.poName} had been delivered?",
                yesButton: 'Complete',
                actionCubit: actionCubit,
                yesButtonOnTap: () async {
                  actionCubit.execute(
                    usecase: CompleteOrderDeliveryUseCase(),
                    params: od,
                  );
                  final ok = await waitActionDone(actionCubit);
                  if (ok && context.mounted) context.pop(true);
                },
              );
              if (changed == true && context.mounted) {
                final change = await context.pushNamed(
                  AppRoutes.orderDeliverySuccess,
                  extra: {'title': 'Product has been delivered'},
                );
                if (change == true && context.mounted) {
                  context.read<OrderDeliveryDisplayCubit>().displayInitial();
                }
              }
            },
            icon: PhosphorIconsFill.flagCheckered,
            label: 'Delivered',
            color: AppColors.green,
          ),
        ],
        child: OrderDeliveryCardWidget(od: od),
      ),
    );
  }
}
