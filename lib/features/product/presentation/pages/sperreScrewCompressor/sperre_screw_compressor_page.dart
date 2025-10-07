import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreScrewCompressor/sperre_screw_compressor_state.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreScrewCompressor/sperre_screw_compressor_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/product_loading_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/sperre_screw_compressor_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SperreScrewCompressorPage extends StatelessWidget {
  const SperreScrewCompressorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SperreScrewCompressorCubit()
                ..displaySperreScrewCompressor(params: ''),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Sperre-Screw Compressor',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        appbarAction: Builder(
          builder: (ctx) {
            return IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsFill.folderPlus,
              iconSize: 24,
              onPressed: () async {
                final sperreCubit = ctx.read<SperreScrewCompressorCubit>();
                final changed = await ctx.pushNamed(
                  AppRoutes.addSperreScrewCompressor,
                );
                if (changed == true && ctx.mounted) {
                  sperreCubit.displaySperreScrewCompressor(params: '');
                }
              },
            );
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
                      context
                          .read<SperreScrewCompressorCubit>()
                          .displayInitial();
                    } else {
                      context
                          .read<SperreScrewCompressorCubit>()
                          .displaySperreScrewCompressor(params: value);
                    }
                  },
                );
              },
            ),
            SizedBox(height: 24),
            Expanded(
              child:
                  BlocBuilder<
                    SperreScrewCompressorCubit,
                    SperreScrewCompressorState
                  >(
                    builder: (context, state) {
                      if (state is SperreScrewCompressorLoading) {
                        return ProductLoadingWidget();
                      }
                      if (state is SperreScrewCompressorFetched) {
                        if (state.sperreScrewCompressor.isEmpty) {
                          return Center(
                            child: TextWidget(text: "There isn't any product."),
                          );
                        } else {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return SperreScrewCompressorCardWidget(
                                product: state.sperreScrewCompressor[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12);
                            },
                            itemCount: state.sperreScrewCompressor.length,
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
}
