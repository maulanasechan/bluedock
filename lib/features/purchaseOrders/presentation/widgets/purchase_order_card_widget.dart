import 'package:bluedock/common/helper/color/string_to_color_helper.dart';
import 'package:bluedock/common/widgets/card/card_container_with_type_widget.dart';
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

    return CardContainerWithTypeWidget(
      typeColor: po.type.color,
      onTap: () async {
        final changed = await context.pushNamed(
          AppRoutes.purchaseOrderDetail,
          extra: {'id': po.purchaseOrderId, 'isEdit': true},
        );
        if (changed == true && context.mounted) {
          context.read<PurchaseOrderDisplayCubit>().displayInitial();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 155,
                child: Row(
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
              ),
              SizedBox(width: 30),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: DateFormat('dd MMM yyyy').format(
                        po.updatedAt != null
                            ? po.updatedAt!.toDate()
                            : po.createdAt.toDate(),
                      ),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final cubit = context.read<PurchaseOrderDisplayCubit>();
                        final res = await sl<FavoritePurchaseOrderUseCase>()
                            .call(params: po.purchaseOrderId);

                        if (!context.mounted) return;

                        final changed = res.isRight();
                        if (changed) {
                          cubit.displayInitial();
                        }
                      },
                      child: PhosphorIcon(
                        isFav
                            ? PhosphorIconsFill.heart
                            : PhosphorIconsBold.heart,
                        color: AppColors.orange,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Row(
            children: [
              SizedBox(
                width: 155,
                child: TitleSubtitleWidget(
                  title: 'Purchase Order Name',
                  subtitle: po.poName,
                ),
              ),
              SizedBox(width: 30),
              TitleSubtitleWidget(
                title: 'Price',
                subtitle: '${po.currency} - ${po.price}',
              ),
            ],
          ),
          SizedBox(height: 12),
          TitleSubtitleWidget(
            title: 'Product',
            subtitle:
                '${po.productCategory!.title} - ${po.productSelection!.productModel}',
          ),
        ],
      ),
    );
  }
}
