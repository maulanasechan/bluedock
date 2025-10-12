import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:flutter/material.dart';

class DailyTaskFormReq {
  final String dailyTaskId;
  final String title;
  final String description;

  final bool projectReference;
  final String projectName;
  final String projectDescription;
  final String projectCategory;
  final String projectModel;
  final String customerCompany;

  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  final List<StaffEntity> listParticipant;
  final TypeCategorySelectionEntity? dailyTaskCategory;

  const DailyTaskFormReq({
    this.projectReference = false,
    this.dailyTaskId = '',
    this.title = '',
    this.description = '',
    this.projectName = '',
    this.projectDescription = '',
    this.projectCategory = '',
    this.projectModel = '',
    this.customerCompany = '',
    this.date,
    this.startTime,
    this.endTime,
    this.listParticipant = const <StaffEntity>[],
    this.dailyTaskCategory,
  });

  factory DailyTaskFormReq.initialWithStartIn(Duration delta) {
    final now = DateTime.now();
    final baseDate = DateTime(now.year, now.month, now.day);

    final dt = now.add(delta);
    final startDate = DateTime(dt.year, dt.month, dt.day);
    final startTod = TimeOfDay(hour: dt.hour, minute: dt.minute);

    return DailyTaskFormReq(
      date: startDate.isAfter(baseDate) ? startDate : baseDate,
      startTime: startTod,
    );
  }

  // --- Sentinel untuk membedakan "tidak diisi" vs "diisi null"
  static const Object _unset = Object();

  DailyTaskFormReq copyWith({
    String? dailyTaskId,
    String? title,
    String? description,
    String? projectName,
    String? projectDescription,
    String? projectCategory,
    String? projectModel,
    String? customerCompany,
    bool? projectReference,

    // Field nullable pakai sentinel:
    Object? date = _unset,
    Object? startTime = _unset,
    Object? endTime = _unset,
    Object? dailyTaskCategory = _unset,

    // opsional: ganti list sekaligus
    List<StaffEntity>? listParticipant,
  }) {
    return DailyTaskFormReq(
      dailyTaskId: dailyTaskId ?? this.dailyTaskId,
      title: title ?? this.title,
      description: description ?? this.description,
      projectName: projectName ?? this.projectName,
      projectDescription: projectDescription ?? this.projectDescription,
      projectCategory: projectCategory ?? this.projectCategory,
      projectModel: projectModel ?? this.projectModel,
      customerCompany: customerCompany ?? this.customerCompany,
      projectReference: projectReference ?? this.projectReference,

      date: identical(date, _unset) ? this.date : date as DateTime?,
      startTime: identical(startTime, _unset)
          ? this.startTime
          : startTime as TimeOfDay?,
      endTime: identical(endTime, _unset)
          ? this.endTime
          : endTime as TimeOfDay?,

      dailyTaskCategory: identical(dailyTaskCategory, _unset)
          ? this.dailyTaskCategory
          : dailyTaskCategory as TypeCategorySelectionEntity?,

      listParticipant: listParticipant ?? this.listParticipant,
    );
  }
}
