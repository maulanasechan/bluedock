import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/dailyTask/presentation/bloc/calendar/calendar_cubit.dart';
import 'package:bluedock/features/dailyTask/presentation/bloc/calendar/calendar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

typedef WeekRangeChanged = void Function(DateTime start, DateTime end);
typedef DayChanged = void Function(DateTime day);

class CalendarWidget extends StatelessWidget {
  final WeekRangeChanged? onWeekRangeChanged;
  final DayChanged? onDayChanged;

  const CalendarWidget({super.key, this.onWeekRangeChanged, this.onDayChanged});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarDisplayCubit, CalendarDisplayState>(
      listenWhen: (prev, curr) =>
          prev is CalendarDisplayFetched && curr is CalendarDisplayFetched
          ? (prev.selectedDay != curr.selectedDay || prev.format != curr.format)
          : false,
      listener: (context, state) {
        if (state is CalendarDisplayFetched && state.selectedDay != null) {
          final d = state.selectedDay!;
          onDayChanged?.call(d);
          if (state.format == CalendarFormat.week &&
              onWeekRangeChanged != null) {
            final (s, e) = CalendarDisplayCubit.weekRangeOf(d);
            onWeekRangeChanged!(s, e);
          }
        }
      },
      builder: (context, state) {
        if (state is CalendarDisplayLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CalendarDisplayFailure) {
          return Center(child: Text(state.message));
        }
        if (state is! CalendarDisplayFetched) {
          return const SizedBox.shrink();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth.clamp(280.0, 1200.0);
            final scaler = MediaQuery.textScalerOf(context);

            final baseRow = (w / 9).clamp(34.0, 56.0);
            final rowHeight = scaler.scale(baseRow).clamp(34.0, 56.0);
            final dowHeight = scaler.scale(baseRow * .45).clamp(16.0, 24.0);

            final headerText = DateFormat(
              'MMMM yyyy',
            ).format(state.selectedDay ?? state.focusedDay);

            final now = DateTime.now();
            final time = DateFormat('HH:mm').format(now);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 70, 20, 0),
                  decoration: BoxDecoration(
                    gradient: AppColors.navbarBackground,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: AppColors.boxShadow,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(text: "Your daily task", fontSize: 14),
                              SizedBox(height: 6),
                              TextWidget(
                                text: headerText,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                          const Spacer(),
                          TextWidget(
                            text: time,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(width: 20),
                          IconButtonWidget(
                            width: 36,
                            iconColor: AppColors.darkBlue,
                            icon: state.format == CalendarFormat.week
                                ? PhosphorIconsBold.arrowsOutLineVertical
                                : PhosphorIconsBold.arrowsInLineVertical,
                            iconSize: 20,
                            onPressed: () => context
                                .read<CalendarDisplayCubit>()
                                .toggleFormat(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        child: TableCalendar(
                          firstDay: DateTime(2000, 1, 1),
                          lastDay: DateTime(2100, 12, 31),
                          focusedDay: state.focusedDay,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          calendarFormat: state.format,

                          rowHeight: rowHeight,
                          daysOfWeekHeight: dowHeight,
                          sixWeekMonthsEnforced: true,

                          selectedDayPredicate: (day) =>
                              state.selectedDay != null &&
                              isSameDay(day, state.selectedDay),

                          onFormatChanged: (_) => context
                              .read<CalendarDisplayCubit>()
                              .toggleFormat(),

                          onPageChanged: (focused) => context
                              .read<CalendarDisplayCubit>()
                              .onPageChanged(focused),

                          onDaySelected: (selected, focused) => context
                              .read<CalendarDisplayCubit>()
                              .onDaySelected(selected, focused),

                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w700,
                            ),
                            weekendStyle: TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          calendarStyle: CalendarStyle(
                            defaultTextStyle: TextStyle(
                              color: AppColors.darkBlue,
                            ),
                            weekendTextStyle: TextStyle(
                              color: AppColors.red,
                              fontWeight: FontWeight.w700,
                            ),
                            outsideTextStyle: TextStyle(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                            disabledTextStyle: TextStyle(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                            isTodayHighlighted: true,
                            todayDecoration: BoxDecoration(
                              color: AppColors.blueSecondary,
                              shape: BoxShape.circle,
                            ),
                            todayTextStyle: TextStyle(
                              color: AppColors.darkBlue,
                            ),
                            selectedTextStyle: const TextStyle(
                              color: AppColors.white,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: AppColors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerVisible: false,
                        ),
                      ),

                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -4,
                  child: Center(
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        final dy = details.primaryDelta ?? 0;
                        final cubit = context.read<CalendarDisplayCubit>();
                        if (dy > 4 && state.format != CalendarFormat.month) {
                          cubit.toggleFormat();
                        } else if (dy < -4 &&
                            state.format != CalendarFormat.week) {
                          cubit.toggleFormat();
                        }
                      },
                      onTap: () =>
                          context.read<CalendarDisplayCubit>().toggleFormat(),
                      child: Container(
                        width: 50,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.blue,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: AppColors.boxShadow,
                              offset: Offset(0, 2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
