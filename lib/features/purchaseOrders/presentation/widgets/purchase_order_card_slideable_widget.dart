import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_cubit.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/purchaseOrders/presentation/widgets/purchase_order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PurchaseOrderCardSlideableWidget extends StatelessWidget {
  final PurchaseOrderEntity po;
  const PurchaseOrderCardSlideableWidget({super.key, required this.po});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        isSlideable: true,
        isUpdated:
            po.projectStatus == 'Active' || po.type.title == 'Purchase Order',
        updateText: po.projectStatus == 'Active' ? 'Fill Data' : 'Update',
        updateIcon: po.projectStatus == 'Active'
            ? PhosphorIconsFill.folderPlus
            : PhosphorIconsFill.gearFine,
        updateColor: po.projectStatus == 'Active'
            ? AppColors.blue
            : AppColors.orange,
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.formPurchaseOrder,
            extra: po,
          );
          if (changed == true && context.mounted) {
            context.read<ProjectDisplayCubit>().displayInitial();
          }
        },
        extentRatio: po.type.title == 'Purchase Order' ? 0.4 : 0.2,
        isDeleted: po.type.title == 'Purchase Order',
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove Purchase Order',
            subtitle: "Are you sure to remove this purchase order?",
            yesButton: 'Remove',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              actionCubit.execute(usecase: DeleteProjectUseCase(), params: po);
              final ok = await waitActionDone(actionCubit);
              if (ok && context.mounted) context.pop(true);
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.successProject,
              extra: {
                'title': '${po.projectName} has been removed',
                'image': AppImages.appProjectDeleted,
              },
            );
            if (change == true && context.mounted) {
              context.read<ProjectDisplayCubit>().displayInitial();
            }
          }
        },
        deleteParams: po.projectId,
        child: PurchaseOrderCardWidget(po: po),
      ),
    );
  }
}
