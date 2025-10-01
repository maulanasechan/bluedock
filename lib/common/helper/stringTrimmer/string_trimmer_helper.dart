String stripSuffix(String? input, String suffix, {bool ignoreCase = true}) {
  final s = (input ?? '').trimRight();
  final pattern = RegExp(
    r'\s*' + RegExp.escape(suffix) + r'$',
    caseSensitive: !ignoreCase,
  );
  return s.replaceFirst(pattern, '').trimRight();
}
