import 'package:bluedock/features/dailyTask/presentation/bloc/calendar/calendar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDisplayCubit extends Cubit<CalendarDisplayState> {
  CalendarDisplayCubit({DateTime? initialDate})
    : super(CalendarDisplayLoading()) {
    // init cepat
    final d = _strip(initialDate ?? DateTime.now());
    emit(
      CalendarDisplayFetched(
        focusedDay: d,
        selectedDay: d,
        format: CalendarFormat.week,
      ),
    );
  }

  static DateTime _strip(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Senin–Minggu dari sebuah tanggal
  static (DateTime start, DateTime end) weekRangeOf(DateTime d) {
    final base = _strip(d);
    final diffToMon = base.weekday - DateTime.monday;
    final start = base.subtract(Duration(days: diffToMon));
    final end = start.add(const Duration(days: 6));
    return (start, end);
  }

  void toggleFormat() {
    final s = state;
    if (s is! CalendarDisplayFetched) return;
    emit(
      s.copyWith(
        format: s.format == CalendarFormat.week
            ? CalendarFormat.month
            : CalendarFormat.week,
      ),
    );
  }

  void onPageChanged(DateTime focused) {
    final s = state;
    if (s is! CalendarDisplayFetched) return;
    emit(s.copyWith(focusedDay: _strip(focused)));
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    final s = state;
    if (s is! CalendarDisplayFetched) return;
    emit(
      s.copyWith(selectedDay: _strip(selected), focusedDay: _strip(focused)),
    );
  }
}
