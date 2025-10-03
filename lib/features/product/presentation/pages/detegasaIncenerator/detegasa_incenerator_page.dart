import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaIncenerator/detegasa_incenerator_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaIncenerator/detegasa_incenerator_state.dart';
import 'package:bluedock/features/product/presentation/widgets/detegasa_incenerator_card_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/product_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DetegasaInceneratorPage extends StatelessWidget {
  const DetegasaInceneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DetegasaInceneratorCubit()
                ..displayDetegasaIncenerator(params: ''),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Detegasa-Incenerator',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        appbarAction: Builder(
          builder: (ctx) {
            return IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsFill.folderPlus,
              iconSize: 24,
              onPressed: () async {
                final sperreCubit = ctx.read<DetegasaInceneratorCubit>();
                final changed = await ctx.pushNamed(
                  AppRoutes.addDetegasaIncenerator,
                );
                if (changed == true && ctx.mounted) {
                  sperreCubit.displayDetegasaIncenerator(params: '');
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
                      context.read<DetegasaInceneratorCubit>().displayInitial();
                    } else {
                      context
                          .read<DetegasaInceneratorCubit>()
                          .displayDetegasaIncenerator(params: value);
                    }
                  },
                );
              },
            ),
            SizedBox(height: 24),
            Expanded(
              child:
                  BlocBuilder<
                    DetegasaInceneratorCubit,
                    DetegasaInceneratorState
                  >(
                    builder: (context, state) {
                      if (state is DetegasaInceneratorLoading) {
                        return ProductLoadingWidget();
                      }
                      if (state is DetegasaInceneratorFetched) {
                        if (state.detegasaIncenerator.isEmpty) {
                          return Center(
                            child: TextWidget(text: "There isn't any product."),
                          );
                        } else {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return DetegasaInceneratorCardWidget(
                                product: state.detegasaIncenerator[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12);
                            },
                            itemCount: state.detegasaIncenerator.length,
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
