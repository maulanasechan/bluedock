import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/domain/entities/sperre_air_compressor_entity.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirCompressor/delete_product_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirCompressor/sperre_air_compressor_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SperreAirCompressoreCardWidget extends StatelessWidget {
  final SperreAirCompressorEntity product;
  const SperreAirCompressoreCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        onUpdateTap: () async {
          final changed = await context.pushNamed(
            AppRoutes.addSperreAirCompressor,
            extra: product,
          );
          if (changed == true && context.mounted) {
            context.read<SperreAirCompressorCubit>().displaySperreAirCompressor(
              params: '',
            );
          }
        },
        onDeleteTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            context: context,
            title: 'Remove Staff',
            subtitle: "Are you sure to remove ${product.productTypeCode}?",
            yesButton: 'Remove',
            actionCubit: actionCubit,
            yesButtonOnTap: () async {
              context.read<ActionButtonCubit>().execute(
                usecase: DeleteProductUseCase(),
                params: ProductReq(
                  productCategoriesId: 'aP9xG7kLmQzR2VtYcJwE',
                  productCategoriesTitle: 'Sperre Air Compressor',
                  productId: product.productId,
                ),
              );
              context.pop(true);
            },
          );
          if (changed == true && context.mounted) {
            final change = await context.pushNamed(
              AppRoutes.successStaff,
              extra: {
                'title': '${product.productTypeCode} has been removed',
                'image': AppImages.appUserDeleted,
              },
            );
            if (change == true && context.mounted) {
              context
                  .read<SperreAirCompressorCubit>()
                  .displaySperreAirCompressor(params: '');
            }
          }
        },
        deleteParams: product.productId,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: PhosphorIcon(
                    PhosphorIconsBold.heart,
                    color: AppColors.orange,
                    size: 28,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 230,
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: 'Max. Delivery Pressure',
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          TextWidget(
                            text: product.maxDeliveryPressure,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 85,
                      height: 80,
                      child: Image.asset(
                        product.image == ""
                            ? AppImages.appSperreAirCompressor
                            : product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
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
                          title: 'Charging Capacity on 50 Hz - 1500 rpm',
                          subtitle: product.chargingCapacity50Hz1500rpm,
                        ),
                        SizedBox(height: 14),
                        TitleSubtitleWidget(
                          title: 'Cooling System',
                          subtitle: product.coolingSystem,
                        ),
                        SizedBox(height: 48),
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
                          title: 'Product Type',
                          subtitle: product.productType,
                        ),
                        SizedBox(height: 14),
                        TitleSubtitleWidget(
                          title: 'Product Type Code',
                          subtitle: product.productTypeCode,
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            TextWidget(
                              text: product.quantity.toString(),
                              color: AppColors.orange,
                              fontWeight: FontWeight.w700,
                              fontSize: 40,
                            ),
                            SizedBox(width: 4),
                            TextWidget(
                              text: 'Unit',
                              color: AppColors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
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
