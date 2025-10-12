({DateTime start, DateTime end}) weekrange(DateTime d) {
  final base = DateTime(d.year, d.month, d.day);
  final diffToMonday = base.weekday - DateTime.monday;
  final start = base.subtract(Duration(days: diffToMonday));
  final end = start.add(const Duration(days: 6));
  return (start: start, end: end);
}
