import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/presentation/bloc/quantumFreshWaterGenerator/quantum_fresh_water_generator_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/quantumFreshWaterGenerator/quantum_fresh_water_generator_state.dart';
import 'package:bluedock/features/product/presentation/widgets/product_loading_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/quantum_fresh_water_generator_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class QuantumFreshWaterGeneratorPage extends StatelessWidget {
  const QuantumFreshWaterGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              QuantumFreshWaterGeneratorCubit()
                ..displayQuantumFreshWaterGenerator(params: ''),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Quantum-Fresh Water Generator',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        fontSizeTitle: 16,
        appbarAction: Builder(
          builder: (ctx) {
            return IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsFill.folderPlus,
              iconSize: 24,
              onPressed: () async {
                final sperreCubit = ctx.read<QuantumFreshWaterGeneratorCubit>();
                final changed = await ctx.pushNamed(
                  AppRoutes.addQuantumFreshWaterGenerator,
                );
                if (changed == true && ctx.mounted) {
                  sperreCubit.displayQuantumFreshWaterGenerator(params: '');
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
                          .read<QuantumFreshWaterGeneratorCubit>()
                          .displayInitial();
                    } else {
                      context
                          .read<QuantumFreshWaterGeneratorCubit>()
                          .displayQuantumFreshWaterGenerator(params: value);
                    }
                  },
                );
              },
            ),
            SizedBox(height: 24),
            Expanded(
              child:
                  BlocBuilder<
                    QuantumFreshWaterGeneratorCubit,
                    QuantumFreshWaterGeneratorState
                  >(
                    builder: (context, state) {
                      if (state is QuantumFreshWaterGeneratorLoading) {
                        return ProductLoadingWidget();
                      }
                      if (state is QuantumFreshWaterGeneratorFetched) {
                        if (state.quantumFreshWaterGenerator.isEmpty) {
                          return Center(
                            child: TextWidget(text: "There isn't any product."),
                          );
                        } else {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return QuantumFreshWaterGeneratorCardWidget(
                                product:
                                    state.quantumFreshWaterGenerator[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12);
                            },
                            itemCount: state.quantumFreshWaterGenerator.length,
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
