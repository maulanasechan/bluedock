import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/search_textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_display_cubit.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_display_state.dart';
import 'package:bluedock/features/orderDeliveries/presentation/widgets/order_delivery_card_slideable_widget.dart';
import 'package:bluedock/features/project/presentation/widgets/project_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ManageOrderDeliveryPage extends StatelessWidget {
  const ManageOrderDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrderDeliveryDisplayCubit()..displayInitial(),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Manage Order Delivery',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        appbarAction: Builder(
          builder: (ctx) {
            return IconButtonWidget(
              iconColor: AppColors.orange,
              icon: PhosphorIconsFill.stackPlus,
              iconSize: 22,
              onPressed: () async {
                final cubit = ctx.read<OrderDeliveryDisplayCubit>();
                final changed = await ctx.pushNamed(
                  AppRoutes.orderDeliveryForm,
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
            BlocBuilder<OrderDeliveryDisplayCubit, OrderDeliveryDisplayState>(
              builder: (context, state) {
                final type = context
                    .read<OrderDeliveryDisplayCubit>()
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
                              .read<OrderDeliveryDisplayCubit>()
                              .displayInitial();
                        } else {
                          context.read<OrderDeliveryDisplayCubit>().setKeyword(
                            value,
                          );
                        }
                      },
                      listFilter: const ['All', 'Inbound', 'Outbound'],
                      selected: selectedLabel,
                      onSelected: (value) {
                        final mapped = value == 'All' ? '' : value;
                        context.read<OrderDeliveryDisplayCubit>().setType(
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
                            text: 'Order Delivery Status:',
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
                    OrderDeliveryDisplayCubit,
                    OrderDeliveryDisplayState
                  >(
                    builder: (context, state) {
                      if (state is OrderDeliveryDisplayLoading) {
                        return ProjectLoadingWidget();
                      }
                      if (state is OrderDeliveryDisplayFetched) {
                        if (state.listOrderDelivery.isEmpty) {
                          return Center(
                            child: TextWidget(
                              text: "There isn't any Order Delivery.",
                            ),
                          );
                        } else {
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return OrderDeliveryCardSlideableWidget(
                                od: state.listOrderDelivery[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12);
                            },
                            itemCount: state.listOrderDelivery.length,
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
