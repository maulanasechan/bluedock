import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String formatOnlyTime(BuildContext context, Timestamp? ts) {
  if (ts == null) return '-';
  final tod = TimeOfDay.fromDateTime(ts.toDate());
  return MaterialLocalizations.of(
    context,
  ).formatTimeOfDay(tod, alwaysUse24HourFormat: true);
}
