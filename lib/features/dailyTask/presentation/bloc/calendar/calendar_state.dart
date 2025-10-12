import 'package:table_calendar/table_calendar.dart';

abstract class CalendarDisplayState {}

class CalendarDisplayLoading extends CalendarDisplayState {}

class CalendarDisplayFailure extends CalendarDisplayState {
  final String message;
  CalendarDisplayFailure({required this.message});
}

/// State utama yang dipakai widget
class CalendarDisplayFetched extends CalendarDisplayState {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat format;

  CalendarDisplayFetched({
    required this.focusedDay,
    required this.selectedDay,
    required this.format,
  });

  CalendarDisplayFetched copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    CalendarFormat? format,
  }) {
    return CalendarDisplayFetched(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      format: format ?? this.format,
    );
  }
}
