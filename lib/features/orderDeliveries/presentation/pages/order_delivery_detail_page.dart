import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/copy_button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:bluedock/features/orderDeliveries/domain/usecases/complete_order_delivery_usecase.dart';
import 'package:bluedock/features/orderDeliveries/domain/usecases/delete_order_delivery_usecase.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_display_cubit.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_display_state.dart';
import 'package:bluedock/features/project/presentation/widgets/project_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrderDeliveryDetailPage extends StatelessWidget {
  final String orderDeliveryId;
  final bool isEdit;
  const OrderDeliveryDetailPage({
    super.key,
    required this.orderDeliveryId,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (context) =>
              OrderDeliveryDisplayCubit()
                ..displayOrderDeliveryById(orderDeliveryId),
        ),
      ],
      child: GradientScaffoldWidget(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
          child:
              BlocConsumer<
                OrderDeliveryDisplayCubit,
                OrderDeliveryDisplayState
              >(
                listener: (context, state) {
                  if (state is OrderDeliveryDisplayFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order delivery not found')),
                    );
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    }
                  }
                },
                builder: (context, state) {
                  if (state is OrderDeliveryDisplayLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is OrderDeliveryDisplayOneFetched) {
                    final orderDelivery = state.orderDelivery;
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
                              child: _avatarWidget(context, orderDelivery),
                            ),
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
                                    color: orderDelivery.status == 'Done'
                                        ? Colors.green
                                        : AppColors.red,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 80,
                                      child: TextWidget(
                                        text: orderDelivery.status,
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
                                _contentWidget(orderDelivery),
                                _bottomNavWidget(context, orderDelivery),
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

  Widget _avatarWidget(
    BuildContext context,
    OrderDeliveryEntity orderDelivery,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(
            orderDelivery.purchaseOrder!.productSelection!.image,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 24),
        TextWidget(
          text: orderDelivery.purchaseOrder!.poName,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        SizedBox(height: 12),
        TextWidget(
          text:
              '${orderDelivery.purchaseOrder!.productCategory!.title} - ${orderDelivery.purchaseOrder!.productSelection!.productModel}',
          fontSize: 16,
        ),
        SizedBox(height: 20),
        ButtonWidget(
          width: 200,
          height: 40,
          onPressed: () async {
            final changed = await context.pushNamed(
              AppRoutes.purchaseOrderDetail,
              extra: {'id': orderDelivery.purchaseOrder!.purchaseOrderId},
            );
            if (changed == true && context.mounted) {
              context.pop(true);
            }
          },
          background: AppColors.blue,
          title: 'See Purchase Order Detail',
          fontSize: 14,
        ),
      ],
    );
  }

  Widget _contentWidget(OrderDeliveryEntity orderDelivery) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                      title: 'Total Price',
                      subTitle:
                          '${orderDelivery.currency} - ${formatWithDot(orderDelivery.price.toString())}',
                    ),
                  ),
                  SizedBox(width: 30),
                  if (orderDelivery.listComponent.isEmpty)
                    ProjectTextWidget(
                      title: 'Quantity',
                      subTitle:
                          '${orderDelivery.purchaseOrder!.quantity[0]} Unit',
                    ),
                ],
              ),
              if (orderDelivery.listComponent.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: orderDelivery.listComponent.length,
                  itemBuilder: (context, index) {
                    final selectedInv =
                        (orderDelivery.listComponent.length > index)
                        ? orderDelivery.listComponent[index].stockName
                        : null;

                    final unitText = (orderDelivery.listQuantity.length > index)
                        ? orderDelivery.listQuantity[index].toString()
                        : '';

                    return ProjectTextWidget(
                      title:
                          '${orderDelivery.listComponent.length > 1 ? 'Component ${index + 1}' : 'Component'} ',
                      subTitle: '$selectedInv - $unitText Unit',
                    );
                  },
                ),
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: orderDelivery.type == 'Outbound'
                          ? 'BL Date'
                          : 'Delivery Date',
                      subTitle: DateFormat(
                        'dd MMMM yyyy',
                      ).format(orderDelivery.deliveryDate.toDate()),
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Estimated Date',
                    subTitle: DateFormat(
                      'dd MMMM yyyy',
                    ).format(orderDelivery.estimatedDate.toDate()),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProjectTextWidget(
                    title: orderDelivery.type == 'Outbound'
                        ? 'BL Number'
                        : 'Tracking Id',
                    subTitle:
                        '${orderDelivery.type == 'Outbound' ? orderDelivery.blNumber : orderDelivery.trackingId}',
                  ),
                  CopyButtonWidget(
                    text:
                        '${orderDelivery.type == 'Outbound' ? orderDelivery.blNumber : orderDelivery.trackingId}',
                  ),
                ],
              ),
              ProjectTextWidget(
                title: 'Shipper Company',
                subTitle: orderDelivery.shipperCompany,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProjectTextWidget(
                    title: 'Shipper Contact',
                    subTitle: '+${orderDelivery.shipperContact}',
                  ),
                  CopyButtonWidget(text: '+${orderDelivery.shipperContact}'),
                ],
              ),
              ProjectTextWidget(
                title: orderDelivery.type == 'Outbound'
                    ? 'BL Location'
                    : 'Discharge Location',
                subTitle: orderDelivery.dischargeLocation,
              ),
              ProjectTextWidget(
                title: 'Destination Location',
                subTitle: orderDelivery.arrivalLocation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavWidget(
    BuildContext context,
    OrderDeliveryEntity orderDelivery,
  ) {
    return Builder(
      builder: (context) {
        if (!isEdit) return SizedBox();
        return Column(
          children: [
            SizedBox(height: 50),
            if (orderDelivery.status == 'Processed')
              ButtonWidget(
                onPressed: () async {
                  final actionCubit = context.read<ActionButtonCubit>();
                  final changed = await CenterModalWidget.display(
                    context: context,
                    title: 'Complete Delivery',
                    subtitle:
                        "Are you sure this ${orderDelivery.purchaseOrder?.poName} had been delivered?",
                    yesButton: 'Complete',
                    actionCubit: actionCubit,
                    yesButtonOnTap: () {
                      context.read<ActionButtonCubit>().execute(
                        usecase: CompleteOrderDeliveryUseCase(),
                        params: orderDelivery,
                      );
                      context.pop(true);
                    },
                  );
                  if (changed == true && context.mounted) {
                    final change = await context.pushNamed(
                      AppRoutes.orderDeliverySuccess,
                      extra: {'title': 'Product has been delivered'},
                    );

                    if (change == true && context.mounted) {
                      context.pop(true);
                    }
                  }
                },
                background: AppColors.green,
                title: 'Complete Delivery',
                fontSize: 16,
              ),
            if (orderDelivery.status == 'Processed') SizedBox(height: 12),
            if (orderDelivery.status == 'Processed')
              ButtonWidget(
                onPressed: () async {
                  final changed = await context.pushNamed(
                    AppRoutes.orderDeliveryForm,
                    extra: orderDelivery,
                  );
                  if (changed == true && context.mounted) {
                    context.pop(true);
                  }
                },
                background: AppColors.orange,
                title: 'Update Order Delivery',
                fontSize: 16,
              ),
            if (orderDelivery.status == 'Processed') SizedBox(height: 12),
            if (orderDelivery.status == 'Processed')
              ButtonWidget(
                onPressed: () async {
                  final actionCubit = context.read<ActionButtonCubit>();
                  final changed = await CenterModalWidget.display(
                    context: context,
                    title: 'Remove Order Delivery',
                    subtitle:
                        "Are you sure to remove ${orderDelivery.purchaseOrder!.poName}?",
                    yesButton: 'Remove',
                    actionCubit: actionCubit,
                    yesButtonOnTap: () {
                      context.read<ActionButtonCubit>().execute(
                        usecase: DeleteOrderDeliveryUseCase(),
                        params: orderDelivery,
                      );
                      context.pop(true);
                    },
                  );
                  if (changed == true && context.mounted) {
                    final change = await context.pushNamed(
                      AppRoutes.orderDeliverySuccess,
                      extra: {
                        'title':
                            '${orderDelivery.purchaseOrder!.poName} has been removed',
                        'image': AppImages.appTaskDeleted,
                      },
                    );

                    if (change == true && context.mounted) {
                      context.pop(true);
                    }
                  }
                },
                background: AppColors.red,
                title: 'Delete Order Delivery',
                fontSize: 16,
              ),
            SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
