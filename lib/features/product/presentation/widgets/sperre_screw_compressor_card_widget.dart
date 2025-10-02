import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_screw_compressor_entity.dart';
import 'package:bluedock/features/product/domain/usecases/product/delete_product_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/product/favorite_product_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreScrewCompressor/sperre_screw_compressor_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/product_rich_text_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SperreScrewCompressorCardWidget extends StatelessWidget {
  final SperreScrewCompressorEntity product;
  const SperreScrewCompressorCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isFav = uid != null && product.favorites.contains(uid);
    final productReq = ProductReq(
      productCategoriesId: 'Zx4nB8qHtUvL5rOaWsKd',
      productCategoriesTitle: 'Sperre Screw Compressor',
      productId: product.productId,
    );

    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.addSperreScrewCompressor,
            extra: product,
          );
          if (changed == true && context.mounted) {
            context
                .read<SperreScrewCompressorCubit>()
                .displaySperreScrewCompressor(params: '');
          }
        },
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove Product',
            subtitle: "Are you sure to remove ${product.productTypeCode}?",
            yesButton: 'Remove',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              actionCubit.execute(
                usecase: DeleteProductUseCase(),
                params: productReq,
              );
              final ok = await waitActionDone(actionCubit);
              if (ok && context.mounted) context.pop(true);
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.successProduct,
              extra: {
                'title': '${product.productTypeCode} has been removed',
                'image': AppImages.appProductDeleted,
              },
            );
            if (change == true && context.mounted) {
              context
                  .read<SperreScrewCompressorCubit>()
                  .displaySperreScrewCompressor(params: '');
            }
          }
        },
        deleteParams: product.productId,
        child: CardContainerWidget(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final cubit = context.read<SperreScrewCompressorCubit>();
                    final res = await sl<FavoriteProductUseCase>().call(
                      params: productReq,
                    );

                    if (!context.mounted) return;

                    final changed = res.isRight();
                    if (changed) {
                      cubit.displaySperreScrewCompressor(params: '');
                    }
                  },
                  child: PhosphorIcon(
                    isFav ? PhosphorIconsFill.heart : PhosphorIconsBold.heart,
                    color: AppColors.orange,
                    size: 28,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ProductRichTextWidget(title: product.quantity.toString()),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 100,
                      child: Image.asset(
                        product.image == ""
                            ? AppImages.appSperreScrewCompressor
                            : product.image,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleSubtitleWidget(
                              title: 'Product Usage',
                              subtitle: product.productUsage,
                            ),
                            SizedBox(height: 14),
                            TitleSubtitleWidget(
                              title: 'Product Type',
                              subtitle: product.productType,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 32),
                      SizedBox(
                        width: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleSubtitleWidget(
                              title: 'Cooling System',
                              subtitle: product.coolingSystem,
                            ),
                            SizedBox(height: 14),
                            TitleSubtitleWidget(
                              title: 'Product Type Code',
                              subtitle: product.productTypeCode,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26),
                  TextWidget(
                    text: 'Charging Capacity for Working Pressure',
                    fontSize: 12,
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 230,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        _textWidget(
                          'Charging - 8 Bar :',
                          product.chargingCapacity8Bar,
                        ),
                        SizedBox(height: 8),
                        _textWidget(
                          'Charging - 10 Bar :',
                          product.chargingCapacity10Bar,
                        ),
                        SizedBox(height: 8),
                        _textWidget(
                          'Charging - 12.5 Bar :',
                          product.chargingCapacity12_5Bar,
                        ),
                      ],
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

  Widget _textWidget(String title, String subTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: title,
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: AppColors.white,
        ),
        TextWidget(
          text: subTitle,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: AppColors.white,
        ),
      ],
    );
  }
}
