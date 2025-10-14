import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/search_textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirSystemSolutions/sperre_air_system_solutions_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirSystemSolutions/sperre_air_system_solutions_state.dart';
import 'package:bluedock/features/product/presentation/widgets/product_loading_widget.dart';
import 'package:bluedock/features/product/presentation/widgets/sperre_air_system_solutions_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SperreAirSystemSolutionsPage extends StatelessWidget {
  const SperreAirSystemSolutionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SperreAirSystemSolutionsCubit()
                ..displaySperreAirSystemSolutions(params: ''),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Sperre-Air System Solutions',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        appbarAction: Builder(
          builder: (ctx) {
            return IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsFill.folderPlus,
              iconSize: 24,
              onPressed: () async {
                final cubit = ctx.read<SperreAirSystemSolutionsCubit>();
                final changed = await ctx.pushNamed(
                  AppRoutes.addSperreAirSystemSolutions,
                );
                if (changed == true && ctx.mounted) {
                  cubit.displaySperreAirSystemSolutions(params: '');
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
                          .read<SperreAirSystemSolutionsCubit>()
                          .displayInitial();
                    } else {
                      context
                          .read<SperreAirSystemSolutionsCubit>()
                          .displaySperreAirSystemSolutions(params: value);
                    }
                  },
                );
              },
            ),
            SizedBox(height: 24),
            Expanded(
              child:
                  BlocBuilder<
                    SperreAirSystemSolutionsCubit,
                    SperreAirSystemSolutionsState
                  >(
                    builder: (context, state) {
                      if (state is SperreAirSystemSolutionsLoading) {
                        return ProductLoadingWidget();
                      }
                      if (state is SperreAirSystemSolutionsFetched) {
                        if (state.sperreAirSystemSolutions.isEmpty) {
                          return Center(
                            child: TextWidget(text: "There isn't any product."),
                          );
                        } else {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return SperreAirSystemSolutionsCardWidget(
                                product: state.sperreAirSystemSolutions[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12);
                            },
                            itemCount: state.sperreAirSystemSolutions.length,
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
