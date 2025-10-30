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
import 'package:bluedock/features/project/presentation/widgets/project_text_widget.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/delete_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_cubit.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PurchaseOrderDetailPage extends StatelessWidget {
  final String purchaseOrderId;
  final bool isEdit;
  const PurchaseOrderDetailPage({
    super.key,
    required this.purchaseOrderId,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (context) =>
              PurchaseOrderDisplayCubit()
                ..displayPurchaseOrderById(purchaseOrderId),
        ),
      ],
      child: GradientScaffoldWidget(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
          child:
              BlocConsumer<
                PurchaseOrderDisplayCubit,
                PurchaseOrderDisplayState
              >(
                listener: (context, state) {
                  if (state is PurchaseOrderDisplayFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Purchase Order not found')),
                    );
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    }
                  }
                },
                builder: (context, state) {
                  if (state is PurchaseOrderDisplayLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is PurchaseOrderDisplayOneFetched) {
                    final purchaseOrder = state.purchaseOrder;
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
                              child: _avatarWidget(context, purchaseOrder),
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
                                    color: purchaseOrder.status == 'Inactive'
                                        ? AppColors.red
                                        : Colors.green,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 80,
                                      child: TextWidget(
                                        text: purchaseOrder.status,
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
                                _contentWidget(purchaseOrder),
                                _bottomNavWidget(context, purchaseOrder),
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
    PurchaseOrderEntity purchaseOrder,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(
            purchaseOrder.productSelection!.image,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 24),
        TextWidget(
          text: purchaseOrder.poName,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        SizedBox(height: 20),
        if (purchaseOrder.project != null)
          ButtonWidget(
            width: 180,
            height: 40,
            onPressed: () async {
              final changed = await context.pushNamed(
                purchaseOrder.type.title == 'Project'
                    ? AppRoutes.projectDetail
                    : AppRoutes.projectDetail,
                extra: {
                  'id': purchaseOrder.type.title == 'Project'
                      ? purchaseOrder.project!.projectId
                      : purchaseOrder.project!.projectId,
                },
              );
              if (changed == true && context.mounted) {
                context.pop(true);
              }
            },
            background: AppColors.blue,
            title: 'See ${purchaseOrder.type.title} Detail',
            fontSize: 14,
          ),
      ],
    );
  }

  Widget _contentWidget(PurchaseOrderEntity purchaseOrder) {
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
              if (purchaseOrder.project != null)
                Row(
                  children: [
                    SizedBox(
                      width: 155,
                      child: ProjectTextWidget(
                        title: 'Project Name',
                        subTitle: purchaseOrder.project!.projectName,
                      ),
                    ),
                    SizedBox(width: 30),
                    ProjectTextWidget(
                      title: 'Project Code',
                      subTitle: purchaseOrder.project!.projectCode,
                    ),
                  ],
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Seller Company',
                      subTitle: purchaseOrder.sellerCompany,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Price',
                    subTitle:
                        '${purchaseOrder.currency} - ${formatWithDot(purchaseOrder.price.toString())}',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProjectTextWidget(
                    title: 'Seller Contact',
                    subTitle:
                        '${purchaseOrder.sellerName} - +${purchaseOrder.sellerContact}',
                  ),
                  CopyButtonWidget(text: '+${purchaseOrder.sellerContact}'),
                ],
              ),
              ProjectTextWidget(
                title: 'Product Type',
                subTitle:
                    '${purchaseOrder.productCategory!.title} - ${purchaseOrder.productSelection!.productModel}',
              ),
              if (purchaseOrder.listComponent.isEmpty)
                ProjectTextWidget(
                  title: 'Quantity',
                  subTitle: '${purchaseOrder.quantity[0]} Unit',
                ),
              if (purchaseOrder.listComponent.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: purchaseOrder.listComponent.length,
                  itemBuilder: (context, index) {
                    final selectedInv =
                        (purchaseOrder.listComponent.length > index)
                        ? purchaseOrder.listComponent[index].stockName
                        : null;

                    final unitText = (purchaseOrder.quantity.length > index)
                        ? purchaseOrder.quantity[index].toString()
                        : '';

                    return ProjectTextWidget(
                      title:
                          '${purchaseOrder.listComponent.length > 1 ? 'Component ${index + 1}' : 'Component'} ',
                      subTitle: '$selectedInv - $unitText Unit',
                    );
                  },
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Issued Date',
                      subTitle: DateFormat('dd MMM yyyy, HH:mm').format(
                        purchaseOrder.updatedAt == null
                            ? purchaseOrder.createdAt.toDate()
                            : purchaseOrder.updatedAt!.toDate(),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: ProjectTextWidget(
                      title: 'Issued By',
                      subTitle:
                          purchaseOrder.updatedBy ?? purchaseOrder.createdBy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavWidget(
    BuildContext context,
    PurchaseOrderEntity purchaseOrder,
  ) {
    return Builder(
      builder: (context) {
        if (!isEdit) return SizedBox();
        return Column(
          children: [
            SizedBox(height: 50),
            if (purchaseOrder.status == 'Inactive')
              ButtonWidget(
                onPressed: () async {
                  final changed = await context.pushNamed(
                    AppRoutes.formPurchaseOrder,
                    extra: purchaseOrder,
                  );
                  if (changed == true && context.mounted) {
                    context.pop(true);
                  }
                },
                background: AppColors.orange,
                title: 'Update Purchase Order',
                fontSize: 16,
              ),
            if (purchaseOrder.status == 'Inactive') SizedBox(height: 12),
            if (purchaseOrder.status == 'Inactive')
              ButtonWidget(
                onPressed: () async {
                  final actionCubit = context.read<ActionButtonCubit>();
                  final changed = await CenterModalWidget.display(
                    context: context,
                    title: 'Remove Purchase Order',
                    subtitle: "Are you sure to remove ${purchaseOrder.poName}?",
                    yesButton: 'Remove',
                    actionCubit: actionCubit,
                    yesButtonOnTap: () {
                      context.read<ActionButtonCubit>().execute(
                        usecase: DeletePurchaseOrderUseCase(),
                        params: purchaseOrder.purchaseOrderId,
                      );
                      context.pop(true);
                    },
                  );
                  if (changed == true && context.mounted) {
                    final change = await context.pushNamed(
                      AppRoutes.purchaseOrderSuccess,
                      extra: {
                        'title': '${purchaseOrder.poName} has been removed',
                        'image': AppImages.appProjectDeleted,
                      },
                    );
                    if (change == true && context.mounted) {
                      context.pop(true);
                    }
                  }
                },
                background: AppColors.red,
                title: 'Delete Purchase Order',
                fontSize: 16,
              ),
            SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
