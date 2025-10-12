import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/dailyTask/presentation/bloc/calendar/calendar_cubit.dart';
import 'package:bluedock/features/dailyTask/presentation/bloc/dailyTask/daily_task_display_cubit.dart';
import 'package:bluedock/features/dailyTask/presentation/bloc/dailyTask/daily_task_display_state.dart';
import 'package:bluedock/features/dailyTask/presentation/widgets/calendar_widget.dart';
import 'package:bluedock/features/dailyTask/presentation/widgets/daily_task_card_widget.dart';
import 'package:bluedock/features/dailyTask/presentation/widgets/daily_task_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DailyTaskPage extends StatelessWidget {
  const DailyTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      hideBack: true,
      showBottomNavigation: true,
      currentIndex: 1,
      bodyPadding: EdgeInsets.fromLTRB(0, 0, 0, 40),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ActionButtonCubit()),
          BlocProvider(create: (context) => CalendarDisplayCubit()),
          BlocProvider(
            create: (context) =>
                DailyTaskDisplayCubit()
                  ..displayDailyTask(params: DateTime.now()),
          ),
        ],
        child: Stack(
          children: [
            Column(
              children: [
                Builder(
                  builder: (ctx) => CalendarWidget(
                    onDayChanged: (day) {
                      ctx.read<DailyTaskDisplayCubit>().displayDailyTask(
                        params: day,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                    child:
                        BlocBuilder<
                          DailyTaskDisplayCubit,
                          DailyTaskDisplayState
                        >(
                          builder: (context, state) {
                            if (state is DailyTaskDisplayLoading) {
                              return DailyTaskLoadingWidget();
                            }
                            if (state is DailyTaskDisplayFailure) {
                              return DailyTaskLoadingWidget();
                            }
                            if (state is DailyTaskDisplayFetched) {
                              if (state.listDailyTask.isEmpty) {
                                return Center(
                                  child: TextWidget(
                                    text: "There isn't any task this day.",
                                  ),
                                );
                              } else {
                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return DailyTaskCardWidget(
                                      dailyTask: state.listDailyTask[index],
                                      index: index,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 18);
                                  },
                                  itemCount: state.listDailyTask.length,
                                );
                              }
                            }
                            return SizedBox();
                          },
                        ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 60,
              right: 20,
              child: Builder(
                builder: (ctx) {
                  return IconButtonWidget(
                    width: 60,
                    iconColor: AppColors.orange,
                    icon: PhosphorIconsFill.calendarPlus,
                    iconSize: 28,
                    onPressed: () async {
                      final cubit = ctx.read<DailyTaskDisplayCubit>();
                      final calendar = ctx.read<CalendarDisplayCubit>();

                      final changed = await ctx.pushNamed(
                        AppRoutes.formDailyTask,
                      );
                      if (changed == true && ctx.mounted) {
                        cubit.displayDailyTask(params: DateTime.now());
                        calendar.onDaySelected(DateTime.now(), DateTime.now());
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
