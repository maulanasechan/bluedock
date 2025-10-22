import 'package:bluedock/common/helper/color/string_to_color_helper.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/favorite_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_cubit.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PurchaseOrderCardWidget extends StatelessWidget {
  final PurchaseOrderEntity po;
  const PurchaseOrderCardWidget({super.key, required this.po});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isFav = uid != null && po.favorites.contains(uid);

    return GestureDetector(
      onTap: () async {
        final changed = await context.pushNamed(
          AppRoutes.purchaseOrderDetail,
          extra: po.purchaseOrderId,
        );
        if (changed == true && context.mounted) {
          context.read<PurchaseOrderDisplayCubit>().displayInitial();
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
        decoration: BoxDecoration(
          color: parseHexColor(po.type.color),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: AppColors.boxShadow,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(left: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 26,
                        height: 26,
                        child: Image.asset(po.type.image, fit: BoxFit.contain),
                      ),
                      SizedBox(width: 8),
                      TextWidget(
                        text: po.type.title,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: parseHexColor(po.type.color),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final cubit = context.read<PurchaseOrderDisplayCubit>();
                      final res = await sl<FavoritePurchaseOrderUseCase>().call(
                        params: po.purchaseOrderId,
                      );

                      if (!context.mounted) return;

                      final changed = res.isRight();
                      if (changed) {
                        cubit.displayInitial();
                      }
                    },
                    child: PhosphorIcon(
                      isFav ? PhosphorIconsFill.heart : PhosphorIconsBold.heart,
                      color: AppColors.orange,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 155,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleSubtitleWidget(
                          title: 'Project Name',
                          subtitle: po.projectName,
                        ),
                        SizedBox(height: 14),
                        TitleSubtitleWidget(
                          title: 'Purchase Contract Number',
                          subtitle: po.purchaseContractNumber,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
                  SizedBox(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleSubtitleWidget(
                          title: 'Project Code',
                          subtitle: po.projectCode,
                        ),
                        SizedBox(height: 14),
                        TitleSubtitleWidget(
                          title: 'Custommer Company',
                          subtitle: po.customerCompany,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: TitleSubtitleWidget(
                      title: 'Product',
                      subtitle:
                          '${po.productCategory.title} - ${po.productSelection.productModel}',
                    ),
                  ),
                  SizedBox(width: 30),
                  SizedBox(
                    width: 150,
                    child: TitleSubtitleWidget(
                      title: 'Component',
                      subtitle: po.componentSelection == null
                          ? "-"
                          : po.componentSelection!.title,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: TitleSubtitleWidget(
                      title: 'Bill of Ladding Date',
                      subtitle: po.blDate == null
                          ? '-'
                          : DateFormat(
                              'dd MMM yyyy, HH:mm',
                            ).format(po.blDate!.toDate()),
                    ),
                  ),
                  SizedBox(width: 30),
                  SizedBox(
                    width: 155,
                    child: TitleSubtitleWidget(
                      title: 'Arrival Date',
                      subtitle: po.blDate == null
                          ? '-'
                          : DateFormat(
                              'dd MMM yyyy, HH:mm',
                            ).format(po.arrivalDate!.toDate()),
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
}
