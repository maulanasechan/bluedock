import 'dart:math' as math;

/// Add months aman (handle akhir bulan, jam/menit tetap)
DateTime _addMonths(DateTime dt, int months) {
  final total = (dt.month - 1) + months;
  final y = dt.year + total ~/ 12;
  final m = (total % 12) + 1;
  final lastDay = DateTime(y, m + 1, 0).day;
  final d = math.min(dt.day, lastDay);
  return dt.isUtc
      ? DateTime.utc(
          y,
          m,
          d,
          dt.hour,
          dt.minute,
          dt.second,
          dt.millisecond,
          dt.microsecond,
        )
      : DateTime(
          y,
          m,
          d,
          dt.hour,
          dt.minute,
          dt.second,
          dt.millisecond,
          dt.microsecond,
        );
}

class FixedWarranty {
  final int blMonths;
  final int comMonths;
  const FixedWarranty({required this.blMonths, required this.comMonths});
}

/// Parse angka bulan dari rule string (fleksibel: months/mos/mths, "bill of lading"/"b/l", "commission/commissioning")
FixedWarranty parseFixedRule(String s) {
  final blRe = RegExp(
    r'(\d+)\s*(?:months?|mos?|mths?)\s*after\s*(?:bill\s*of\s*lading|b\s*/?\s*l)',
    caseSensitive: false,
  );
  final comRe = RegExp(
    r'(\d+)\s*(?:months?|mos?|mths?)\s*after\s*commission\w*',
    caseSensitive: false,
  );

  int bl = int.tryParse(blRe.firstMatch(s)?.group(1) ?? '') ?? 16;
  int cm = int.tryParse(comRe.firstMatch(s)?.group(1) ?? '') ?? 10;
  return FixedWarranty(blMonths: bl, comMonths: cm);
}

/// Kembalikan dua tanggal dalam urutan tetap: [BL + blMonths, Commissioning + comMonths]
List<DateTime?> computeExpiryDatesFromRule({
  required String rule,
  DateTime? billOfLadingDate,
  DateTime? commissioningDate,
}) {
  final r = parseFixedRule(rule);
  final bl = billOfLadingDate == null
      ? null
      : _addMonths(billOfLadingDate, r.blMonths);
  final com = commissioningDate == null
      ? null
      : _addMonths(commissioningDate, r.comMonths);
  return <DateTime?>[bl, com];
}

/// (opsional) ambil yang paling cepat dari dua kandidat
DateTime? earliestDate(List<DateTime?> xs) {
  final v = xs.whereType<DateTime>().toList()..sort();
  return v.isEmpty ? null : v.first;
}
