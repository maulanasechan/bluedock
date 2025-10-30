import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/features/inventories/domain/usecases/delete_inventory_usecase.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_cubit.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_state.dart';
import 'package:bluedock/features/project/presentation/widgets/project_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InventoryDetailPage extends StatelessWidget {
  final String inventoryId;
  const InventoryDetailPage({super.key, required this.inventoryId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (context) =>
              InventoryDisplayCubit()..displayInventoryById(inventoryId),
        ),
      ],
      child: GradientScaffoldWidget(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
          child: BlocBuilder<InventoryDisplayCubit, InventoryDisplayState>(
            builder: (context, state) {
              if (state is InventoryDisplayLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is InventoryDisplayOneFetched) {
                final inventory = state.inventory;
                return Column(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButtonWidget(),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: _avatarWidget(inventory),
                        ),
                        if (inventory.arrivalDate != null)
                          Align(
                            alignment: Alignment.topRight,
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.blue,
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 80,
                                    child: TextWidget(
                                      text: 'Delivery',
                                      fontSize: 16,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                      align: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _contentWidget(inventory),
                            if (inventory.arrivalDate == null)
                              _bottomNavWidget(context, inventory),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _avatarWidget(InventoryEntity inventory) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(
            inventory.productSelection.image == ''
                ? AppImages.appDetegasaIncenerator
                : inventory.productSelection.image,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 24),
        TextWidget(
          text: inventory.stockName,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _contentWidget(InventoryEntity inventory) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Part Number',
                      subTitle: inventory.partNo,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Quantity',
                    subTitle: inventory.quantity.toString(),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Product Category',
                      subTitle: inventory.productCategory.title,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Product Model',
                    subTitle: inventory.productSelection.productModel,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Price',
                      subTitle: "${inventory.currency} ${inventory.price}",
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Arrival Date',
                    subTitle: inventory.arrivalDate != null
                        ? DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(inventory.arrivalDate!.toDate())
                        : '-',
                  ),
                ],
              ),
              ProjectTextWidget(
                title: 'Maintenance Period',
                subTitle: inventory.maintenancePeriod == 0
                    ? "-"
                    : "${inventory.maintenancePeriod} ${inventory.maintenanceCurrency}",
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Created By',
                      subTitle: inventory.createdBy,
                      bottom: 0,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Created At',
                    subTitle: DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(inventory.createdAt.toDate()),
                    bottom: 0,
                  ),
                ],
              ),
              SizedBox(height: inventory.updatedAt != null ? 16 : 0),
              if (inventory.updatedAt != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 155,
                      child: ProjectTextWidget(
                        title: 'Updated By',
                        subTitle: inventory.updatedBy,
                        bottom: 0,
                      ),
                    ),
                    SizedBox(width: 30),
                    ProjectTextWidget(
                      title: 'Updated At',
                      subTitle: DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(inventory.updatedAt!.toDate()),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavWidget(BuildContext context, InventoryEntity inventory) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            SizedBox(height: 50),
            if (inventory.arrivalDate == null)
              ButtonWidget(
                onPressed: () async {
                  final changed = await context.pushNamed(
                    AppRoutes.inventoryForm,
                    extra: inventory,
                  );
                  if (changed == true && context.mounted) {
                    context.pop(true);
                  }
                },
                background: AppColors.orange,
                title: 'Update Stock',
                fontSize: 16,
              ),
            if (inventory.arrivalDate == null) SizedBox(height: 16),
            if (inventory.arrivalDate == null)
              ButtonWidget(
                onPressed: () async {
                  final actionCubit = context.read<ActionButtonCubit>();
                  final changed = await CenterModalWidget.display(
                    context: context,
                    title: 'Remove ${inventory.stockName}',
                    subtitle: "Are you sure to remove ${inventory.stockName}?",
                    yesButton: 'Remove',
                    actionCubit: actionCubit,
                    yesButtonColor: inventory.arrivalDate == null
                        ? AppColors.red
                        : AppColors.blue,
                    yesButtonOnTap: () {
                      context.read<ActionButtonCubit>().execute(
                        usecase: DeleteInventoryUseCase(),
                        params: inventory.inventoryId,
                      );
                      context.pop(true);
                    },
                  );
                  if (changed == true && context.mounted) {
                    final change = await context.pushNamed(
                      AppRoutes.successProject,
                      extra: {
                        'title': '${inventory.stockName} has been removed',
                        'image': AppImages.appProjectDeleted,
                      },
                    );

                    if (change == true && context.mounted) {
                      context.pop(true);
                    }
                  }
                },
                background: AppColors.red,
                title: 'Delete Stock',
                fontSize: 16,
              ),
            SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
