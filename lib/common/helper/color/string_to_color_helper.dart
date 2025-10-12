import 'package:flutter/material.dart';

Color parseHexColor(String input) {
  var hex = input.trim().replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  if (hex.length != 8) {
    throw FormatException('Hex harus 6 (RGB) atau 8 (ARGB) digit');
  }
  return Color(int.parse(hex, radix: 16));
}
