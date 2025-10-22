import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/copy_button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/project/presentation/widgets/project_text_widget.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_cubit.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PurchaseOrderDetailPage extends StatelessWidget {
  final String purchaseOrderId;
  const PurchaseOrderDetailPage({super.key, required this.purchaseOrderId});

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
              BlocBuilder<PurchaseOrderDisplayCubit, PurchaseOrderDisplayState>(
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
                              child: _avatarWidget(purchaseOrder),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _contentWidget(purchaseOrder),
                                if (purchaseOrder.projectStatus == 'Active')
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

  Widget _avatarWidget(PurchaseOrderEntity purchaseOrder) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(
            purchaseOrder.productSelection.image == ''
                ? AppImages.appDetegasaIncenerator
                : purchaseOrder.productSelection.image,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 24),

        TextWidget(
          text: purchaseOrder.purchaseContractNumber,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        SizedBox(width: 20),
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
                      title: 'Project Name',
                      subTitle: purchaseOrder.projectName,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Project Code',
                    subTitle: purchaseOrder.projectCode,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Customer Company',
                      subTitle: purchaseOrder.customerCompany,
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Project Status',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      SizedBox(height: 4),
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: purchaseOrder.projectStatus == 'Inactive'
                                ? AppColors.red
                                : purchaseOrder.projectStatus == 'Done'
                                ? Colors.green
                                : AppColors.orange,
                          ),
                          child: Center(
                            child: TextWidget(
                              text: purchaseOrder.projectStatus,
                              fontSize: 16,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProjectTextWidget(
                    title: 'Customer Contact',
                    subTitle:
                        '${purchaseOrder.customerName} - ${purchaseOrder.customerContact}',
                  ),
                  CopyButtonWidget(text: purchaseOrder.customerContact),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Price',
                      subTitle:
                          '${purchaseOrder.currency} ${formatWithCommas(purchaseOrder.price.toString()) == 'null' ? "-" : formatWithCommas(purchaseOrder.price.toString())}',
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Quantity',
                    subTitle: purchaseOrder.quantity.toString(),
                  ),
                ],
              ),
              ProjectTextWidget(
                title: 'Categories',
                subTitle:
                    '${purchaseOrder.productCategory.title} - ${purchaseOrder.productSelection.productModel}',
              ),

              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Bill of Ladding Date',
                      subTitle: purchaseOrder.blDate == null
                          ? "-"
                          : DateFormat(
                              'dd MMM yyyy',
                            ).format(purchaseOrder.blDate!.toDate()),
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Arrival Date',
                    subTitle: purchaseOrder.arrivalDate == null
                        ? "-"
                        : DateFormat(
                            'dd MMM yyyy',
                          ).format(purchaseOrder.arrivalDate!.toDate()),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Created By',
                      subTitle: purchaseOrder.createdBy,
                      bottom: 0,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Created At',
                    subTitle: DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(purchaseOrder.createdAt.toDate()),
                    bottom: 0,
                  ),
                ],
              ),
              SizedBox(height: purchaseOrder.updatedAt != null ? 16 : 0),
              if (purchaseOrder.updatedAt != null)
                ProjectTextWidget(
                  title: 'Updated At',
                  subTitle: DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(purchaseOrder.updatedAt!.toDate()),
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
        return Column(
          children: [
            SizedBox(height: 50),
            if (purchaseOrder.type.title != 'Purchase Order' &&
                purchaseOrder.projectStatus != 'Commisioning')
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
                background: AppColors.blue,
                title: 'Fill BL Date, Price, Arrival Date',
                fontSize: 16,
              ),
            SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
