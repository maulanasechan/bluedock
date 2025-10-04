import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/domain/entities/detegasa_oily_water_separator_entity.dart';
import 'package:bluedock/features/product/domain/usecases/product/delete_product_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/product/favorite_product_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaOilyWaterSeparator/detegasa_oily_water_separator_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/product_rich_text_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DetegasaOilyWaterSeparatorCardWidget extends StatelessWidget {
  final DetegasaOilyWaterSeparatorEntity product;
  const DetegasaOilyWaterSeparatorCardWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isFav = uid != null && product.favorites.contains(uid);
    final productReq = ProductReq(
      categoryId: 'A7b3C9d2E6f1G5h8J0k4',
      productId: product.productId,
    );

    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.addDetegasaOilyWaterSeparator,
            extra: product,
          );
          if (changed == true && context.mounted) {
            context
                .read<DetegasaOilyWaterSeparatorCubit>()
                .displayDetegasaOilyWaterSeparator(params: '');
          }
        },
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove Product',
            subtitle: "Are you sure to remove ${product.productModel}?",
            yesButton: 'Remove',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              actionCubit.execute(
                usecase: DeleteProductUseCase(),
                params: productReq,
              );
              final ok = await waitActionDone(actionCubit);
              actionCubit.reset();
              if (ok && context.mounted) context.pop(true);
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.successProduct,
              extra: {
                'title': '${product.productModel} has been removed',
                'image': AppImages.appProductDeleted,
              },
            );
            if (change == true && context.mounted) {
              context
                  .read<DetegasaOilyWaterSeparatorCubit>()
                  .displayDetegasaOilyWaterSeparator(params: '');
            }
          }
        },
        deleteParams: product.productId,
        child: CardContainerWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: TitleSubtitleWidget(
                          title: 'Product Model',
                          subtitle: product.productModel,
                        ),
                      ),
                      SizedBox(width: 30),
                      SizedBox(
                        width: 120,
                        child: TitleSubtitleWidget(
                          title: 'Product Capacity',
                          subtitle: product.productCapacity,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final cubit = context
                          .read<DetegasaOilyWaterSeparatorCubit>();
                      final res = await sl<FavoriteProductUseCase>().call(
                        params: productReq,
                      );

                      if (!context.mounted) return;

                      final changed = res.isRight();
                      if (changed) {
                        cubit.displayDetegasaOilyWaterSeparator(params: '');
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
              SizedBox(height: 22),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: TitleSubtitleWidget(
                      title: 'Product Length',
                      subtitle: product.productLength,
                    ),
                  ),
                  SizedBox(width: 30),
                  SizedBox(
                    width: 120,
                    child: TitleSubtitleWidget(
                      title: 'Product Width',
                      subtitle: product.productWidth,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: TitleSubtitleWidget(
                      title: 'Product Height',
                      subtitle: product.productHeight,
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductRichTextWidget(
                          title: product.quantity.toString(),
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            product.image == ""
                                ? AppImages.appDetegasaOilyWaterSeparator
                                : product.image,
                            fit: BoxFit.contain,
                          ),
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
}
