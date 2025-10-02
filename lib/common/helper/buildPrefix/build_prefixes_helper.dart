List<String> buildWordPrefixes(String text) {
  final t = text.trim().toLowerCase();
  if (t.isEmpty) return const [];
  final parts = t.split(RegExp(r'\s+'));
  final out = <String>[];
  for (final p in parts) {
    for (var i = 1; i <= p.length; i++) {
      out.add(p.substring(0, i));
    }
  }
  return out.toSet().toList();
}
