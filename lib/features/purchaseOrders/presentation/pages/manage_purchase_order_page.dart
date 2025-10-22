import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/search_textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/project/presentation/widgets/project_loading_widget.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_cubit.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_state.dart';
import 'package:bluedock/features/purchaseOrders/presentation/widgets/purchase_order_card_slideable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ManagePurchaseOrderPage extends StatelessWidget {
  const ManagePurchaseOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PurchaseOrderDisplayCubit()..displayInitial(),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Manage Purchase Order',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        appbarAction: Builder(
          builder: (ctx) {
            return IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsFill.stackPlus,
              iconSize: 22,
              onPressed: () async {
                final cubit = ctx.read<PurchaseOrderDisplayCubit>();
                final changed = await ctx.pushNamed(
                  AppRoutes.formPurchaseOrder,
                );
                if (changed == true && ctx.mounted) {
                  cubit.displayInitial();
                }
              },
            );
          },
        ),
        body: Column(
          children: [
            BlocBuilder<PurchaseOrderDisplayCubit, PurchaseOrderDisplayState>(
              builder: (context, state) {
                final type = context
                    .read<PurchaseOrderDisplayCubit>()
                    .currentType;
                final selectedLabel = (type.isEmpty)
                    ? 'All'
                    : '${type[0].toUpperCase()}${type.substring(1)}';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchTextfieldWidget(
                      selectedColor: AppColors.blue,
                      withFilter: true,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          context
                              .read<PurchaseOrderDisplayCubit>()
                              .displayInitial();
                        } else {
                          context.read<PurchaseOrderDisplayCubit>().setKeyword(
                            value,
                          );
                        }
                      },
                      listFilter: const [
                        'All',
                        'Aftersales',
                        'Project',
                        'Self Stock',
                      ],
                      selected: selectedLabel,
                      onSelected: (value) {
                        final mapped = value == 'All' ? '' : value;
                        context.read<PurchaseOrderDisplayCubit>().setType(
                          mapped,
                        );
                      },
                    ),
                    SizedBox(height: selectedLabel != 'All' ? 20 : 12),
                    if (selectedLabel != 'All')
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextWidget(
                            text: 'Notification from:',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(width: 6),
                          TextWidget(
                            text: selectedLabel,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blue,
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: 12),
            Expanded(
              child:
                  BlocBuilder<
                    PurchaseOrderDisplayCubit,
                    PurchaseOrderDisplayState
                  >(
                    builder: (context, state) {
                      if (state is PurchaseOrderDisplayLoading) {
                        return ProjectLoadingWidget();
                      }
                      if (state is PurchaseOrderDisplayFetched) {
                        if (state.listPurchaseOrder.isEmpty) {
                          return Center(
                            child: TextWidget(
                              text: "There isn't any Purchase Order.",
                            ),
                          );
                        } else {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return PurchaseOrderCardSlideableWidget(
                                po: state.listPurchaseOrder[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12);
                            },
                            itemCount: state.listPurchaseOrder.length,
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
