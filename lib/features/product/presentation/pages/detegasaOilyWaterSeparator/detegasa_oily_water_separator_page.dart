import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/search_textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaOilyWaterSeparator/detegasa_oily_water_separator_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaOilyWaterSeparator/detegasa_oily_water_separator_state.dart';
import 'package:bluedock/features/product/presentation/widgets/detegasa_oily_water_separator_card_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/product_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DetegasaOilyWaterSeparatorPage extends StatelessWidget {
  const DetegasaOilyWaterSeparatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DetegasaOilyWaterSeparatorCubit()
                ..displayDetegasaOilyWaterSeparator(params: ''),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Detegasa-Oily Water Separator',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        appbarAction: Builder(
          builder: (ctx) {
            return IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsFill.folderPlus,
              iconSize: 24,
              onPressed: () async {
                final sperreCubit = ctx.read<DetegasaOilyWaterSeparatorCubit>();
                final changed = await ctx.pushNamed(
                  AppRoutes.addDetegasaOilyWaterSeparator,
                );
                if (changed == true && ctx.mounted) {
                  sperreCubit.displayDetegasaOilyWaterSeparator(params: '');
                }
              },
            );
          },
        ),

        body: Column(
          children: [
            Builder(
              builder: (context) {
                return SearchTextfieldWidget(
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context
                          .read<DetegasaOilyWaterSeparatorCubit>()
                          .displayInitial();
                    } else {
                      context
                          .read<DetegasaOilyWaterSeparatorCubit>()
                          .displayDetegasaOilyWaterSeparator(params: value);
                    }
                  },
                );
              },
            ),
            SizedBox(height: 24),
            Expanded(
              child:
                  BlocBuilder<
                    DetegasaOilyWaterSeparatorCubit,
                    DetegasaOilyWaterSeparatorState
                  >(
                    builder: (context, state) {
                      if (state is DetegasaOilyWaterSeparatorLoading) {
                        return ProductLoadingWidget();
                      }
                      if (state is DetegasaOilyWaterSeparatorFetched) {
                        if (state.detegasaOilyWaterSeparator.isEmpty) {
                          return Center(
                            child: TextWidget(text: "There isn't any product."),
                          );
                        } else {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return DetegasaOilyWaterSeparatorCardWidget(
                                product:
                                    state.detegasaOilyWaterSeparator[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12);
                            },
                            itemCount: state.detegasaOilyWaterSeparator.length,
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
