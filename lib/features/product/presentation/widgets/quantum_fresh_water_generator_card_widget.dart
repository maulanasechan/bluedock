import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/card_container_widget.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/domain/entities/quantum_fresh_water_generator_entity.dart';
import 'package:bluedock/features/product/domain/usecases/product/delete_product_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/product/favorite_product_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/quantumFreshWaterGenerator/quantum_fresh_water_generator_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/product_rich_text_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class QuantumFreshWaterGeneratorCardWidget extends StatelessWidget {
  final QuantumFreshWaterGeneratorEntity product;
  const QuantumFreshWaterGeneratorCardWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isFav = uid != null && product.favorites.contains(uid);
    final productReq = ProductReq(
      productCategoriesId: 'M3jvF7wXaZpL2yKsTbQr',
      productCategoriesTitle: 'Quantum Fresh Water Generator',
      productId: product.productId,
    );

    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.addQuantumFreshWaterGenerator,
            extra: product,
          );
          if (changed == true && context.mounted) {
            context
                .read<QuantumFreshWaterGeneratorCubit>()
                .displayQuantumFreshWaterGenerator(params: '');
          }
        },
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove Product',
            subtitle: "Are you sure to remove ${product.waterSolutionType}?",
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
                'title': '${product.waterSolutionType} has been removed',
                'image': AppImages.appProductDeleted,
              },
            );
            if (change == true && context.mounted) {
              context
                  .read<QuantumFreshWaterGeneratorCubit>()
                  .displayQuantumFreshWaterGenerator(params: '');
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
                        width: 145,
                        child: TitleSubtitleWidget(
                          title: 'Min. Production Capacity',
                          subtitle: product.minProductionCapacity,
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 148,
                        child: TitleSubtitleWidget(
                          title: 'Max. Production Capacity',
                          subtitle: product.maxProductionCapacity,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      final cubit = context
                          .read<QuantumFreshWaterGeneratorCubit>();
                      final res = await sl<FavoriteProductUseCase>().call(
                        params: productReq,
                      );

                      if (!context.mounted) return;

                      final changed = res.isRight();
                      if (changed) {
                        cubit.displayQuantumFreshWaterGenerator(params: '');
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
                    width: 145,
                    child: TitleSubtitleWidget(
                      title: 'Water Solution Type',
                      subtitle: product.waterSolutionType,
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 148,
                    child: TitleSubtitleWidget(
                      title: 'Tailor-Made Design',
                      subtitle: product.tailorMadeDesign ? 'Yes' : 'No',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(width: 162),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductRichTextWidget(
                          title: product.quantity.toString(),
                        ),
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Image.asset(
                            product.image == ""
                                ? AppImages.appQuantumFreshWaterGenerator
                                : product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TitleSubtitleWidget(
                title: 'Type Description',
                subtitle: product.typeDescription,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
