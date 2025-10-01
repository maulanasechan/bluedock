import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirCompressor/sperre_air_compressor_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirCompressor/sperre_air_compressor_state.dart';
import 'package:bluedock/features/product/presentation/widgets/sperre_air_compressore_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';

class SperreAirCompressorPage extends StatelessWidget {
  const SperreAirCompressorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SperreAirCompressorCubit()..displaySperreAirCompressor(params: ''),
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Sperre-Air Compressor',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        hideBackAction: () {
          context.goNamed(AppRoutes.productCategory);
        },
        appbarAction: IconButtonWidget(
          iconColor: AppColors.orange,
          icon: PhosphorIconsFill.folderPlus,
          iconSize: 24,
          onPressed: () {
            context.pushNamed(AppRoutes.addSperreAirCompressor);
          },
        ),
        body: Column(
          children: [
            Builder(
              builder: (context) {
                return TextfieldWidget(
                  prefixIcon: PhosphorIconsBold.magnifyingGlass,
                  borderRadius: 60,
                  iconColor: AppColors.darkBlue,
                  hintText: 'Search',
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<SperreAirCompressorCubit>().displayInitial();
                    } else {
                      context
                          .read<SperreAirCompressorCubit>()
                          .displaySperreAirCompressor(params: value);
                    }
                  },
                );
              },
            ),
            SizedBox(height: 24),
            Expanded(
              child:
                  BlocBuilder<
                    SperreAirCompressorCubit,
                    SperreAirCompressorState
                  >(
                    builder: (context, state) {
                      if (state is SperreAirCompressorLoading) {
                        return _productLoading();
                      }
                      if (state is SperreAirCompressorFetched) {
                        if (state.sperreAirCompressor.isEmpty) {
                          return Center(
                            child: TextWidget(text: "There isn't any product."),
                          );
                        } else {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return SperreAirCompressoreCardWidget(
                                product: state.sperreAirCompressor[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 18);
                            },
                            itemCount: state.sperreAirCompressor.length,
                          );
                        }
                      }
                      return SizedBox();
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.baseLoading,
      highlightColor: AppColors.highlightLoading,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) {
          return SizedBox(height: 18);
        },
        itemBuilder: (context, index) {
          return Container(
            width: double.maxFinite,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.red,
            ),
          );
        },
        itemCount: 8,
      ),
    );
  }
}
