import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_system_solutions_entity.dart';
import 'package:bluedock/features/product/domain/usecases/product/delete_product_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/product/favorite_product_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirSystemSolutions/sperre_air_system_solutions_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/product_rich_text_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SperreAirSystemSolutionsCardWidget extends StatelessWidget {
  final SperreAirSystemSolutionsEntity product;
  const SperreAirSystemSolutionsCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isFav = uid != null && product.favorites.contains(uid);
    final productReq = ProductReq(
      productCategoriesId: 'tG6pN1yXcQwE9bJmRvUh',
      productCategoriesTitle: 'Sperre Air System Solutions',
      productId: product.productId,
    );

    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.addSperreAirSystemSolutions,
            extra: product,
          );
          if (changed == true && context.mounted) {
            context
                .read<SperreAirSystemSolutionsCubit>()
                .displaySperreAirSystemSolutions(params: '');
          }
        },
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove Product',
            subtitle: "Are you sure to remove ${product.productName}?",
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
                'title': '${product.productName} has been removed',
                'image': AppImages.appProductDeleted,
              },
            );
            if (change == true && context.mounted) {
              context
                  .read<SperreAirSystemSolutionsCubit>()
                  .displaySperreAirSystemSolutions(params: '');
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
                        width: 140,
                        child: TitleSubtitleWidget(
                          title: 'Product Usage',
                          subtitle: product.productUsage,
                        ),
                      ),
                      SizedBox(width: 32),
                      TitleSubtitleWidget(
                        title: 'Product Name',
                        subtitle: product.productName,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final cubit = context
                          .read<SperreAirSystemSolutionsCubit>();
                      final res = await sl<FavoriteProductUseCase>().call(
                        params: productReq,
                      );

                      if (!context.mounted) return;

                      final changed = res.isRight();
                      if (changed) {
                        cubit.displaySperreAirSystemSolutions(params: '');
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
              SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: TitleSubtitleWidget(
                          title: 'Product Category',
                          subtitle: product.productCategory,
                        ),
                      ),
                      SizedBox(width: 32),
                      ProductRichTextWidget(title: product.quantity.toString()),
                    ],
                  ),
                  SizedBox(
                    width: 75,
                    height: 70,
                    child: Image.asset(
                      product.image == ""
                          ? AppImages.appSperreAirCompressor
                          : product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22),
              TitleSubtitleWidget(
                title: 'Product Explanation',
                subtitle: product.productExplanation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
