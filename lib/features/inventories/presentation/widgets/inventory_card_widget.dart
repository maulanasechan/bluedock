import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/features/inventories/domain/usecases/favorite_inventory_usecase.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class InventoryCardWidget extends StatelessWidget {
  final InventoryEntity inventory;
  const InventoryCardWidget({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isFav = uid != null && inventory.favorites.contains(uid);

    return CardContainerWidget(
      onTap: () async {
        final changed = await context.pushNamed(
          AppRoutes.inventoryDetail,
          extra: inventory.inventoryId,
        );
        if (changed == true && context.mounted) {
          context.read<InventoryDisplayCubit>().displayInitial();
        }
      },
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                final cubit = context.read<InventoryDisplayCubit>();
                final res = await sl<FavoriteInventoryUseCase>().call(
                  params: inventory.inventoryId,
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
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          title: 'Name',
                          subtitle: inventory.stockName,
                        ),
                        if (inventory.arrivalDate != null) SizedBox(height: 14),
                        if (inventory.arrivalDate != null)
                          TitleSubtitleWidget(
                            title: 'Arrival Date',
                            subtitle: DateFormat(
                              'dd MMM yyyy, HH:mm',
                            ).format(inventory.arrivalDate!.toDate()),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
                  SizedBox(
                    width: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleSubtitleWidget(
                          title: 'Quantity',
                          subtitle: inventory.quantity.toString(),
                        ),
                        if (inventory.arrivalDate != null) SizedBox(height: 14),
                        if (inventory.arrivalDate != null)
                          TextWidget(
                            text: 'Status',
                            fontSize: 12,
                            overflow: TextOverflow.fade,
                          ),
                        if (inventory.arrivalDate != null) SizedBox(height: 4),
                        if (inventory.arrivalDate != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.blue,
                            ),
                            child: TextWidget(
                              text: 'Delivery',
                              fontSize: 12,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
