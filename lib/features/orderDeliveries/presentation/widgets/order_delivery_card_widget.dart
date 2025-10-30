import 'package:bluedock/common/helper/color/string_to_color_helper.dart';
import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/widgets/card/card_container_with_type_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:bluedock/features/orderDeliveries/domain/usecases/favorite_order_delivery_usecase.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_display_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrderDeliveryCardWidget extends StatelessWidget {
  final OrderDeliveryEntity od;
  const OrderDeliveryCardWidget({super.key, required this.od});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isFav = uid != null && od.favorites.contains(uid);

    return CardContainerWithTypeWidget(
      typeColor: od.type == 'Inbound' ? '0F6CBB' : 'F37908',
      onTap: () async {
        final changed = await context.pushNamed(
          AppRoutes.orderDeliveryDetail,
          extra: {'id': od.deliveryOrderId, 'isEdit': true},
        );
        if (changed == true && context.mounted) {
          context.read<OrderDeliveryDisplayCubit>().displayInitial();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 155,
                child: TextWidget(
                  text: od.type,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: parseHexColor(
                    od.type == 'Inbound' ? '0F6CBB' : 'F37908',
                  ),
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: DateFormat('dd MMM yyyy').format(
                        od.updatedAt != null
                            ? od.updatedAt!.toDate()
                            : od.createdAt.toDate(),
                      ),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final cubit = context.read<OrderDeliveryDisplayCubit>();
                        final res = await sl<FavoriteOrderDeliveryUseCase>()
                            .call(params: od.deliveryOrderId);

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
                  subtitle: od.purchaseOrder!.poName,
                ),
              ),
              SizedBox(width: 30),
              TitleSubtitleWidget(
                title: 'Price',
                subtitle:
                    '${od.currency} - ${formatWithDot(od.price.toString())}',
              ),
            ],
          ),
          SizedBox(height: 12),
          TitleSubtitleWidget(
            title: 'Product',
            subtitle:
                '${od.purchaseOrder!.productCategory!.title} - ${od.purchaseOrder!.productSelection!.productModel}',
          ),
        ],
      ),
    );
  }
}
