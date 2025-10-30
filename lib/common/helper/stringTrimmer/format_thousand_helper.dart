import 'package:intl/intl.dart';

String formatWithCommas(String raw) {
  if (raw.isEmpty) return raw;
  final cleaned = raw.replaceAll(',', '').trim();
  final n = num.tryParse(cleaned);
  if (n == null) return raw;

  final hasDecimal = cleaned.contains('.');
  final fmt = NumberFormat(
    hasDecimal ? '#,##0.################' : '#,##0',
    'en_US',
  );
  return fmt.format(n);
}

String formatWithDot(String raw) {
  if (raw.isEmpty) return raw;
  final cleaned = raw.replaceAll('.', '').trim();
  final n = num.tryParse(cleaned);
  if (n == null) return raw;

  final hasDecimal = cleaned.contains('.');
  final fmt = NumberFormat(
    hasDecimal ? '#,##0.################' : '#,##0',
    'en_US',
  );
  return fmt.format(n);
}

String removeCommas(String raw) => raw.replaceAll(',', '');
