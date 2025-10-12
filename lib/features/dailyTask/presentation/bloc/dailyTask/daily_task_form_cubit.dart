import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/features/dailyTask/data/models/daily_task_form_req.dart';
import 'package:bluedock/features/dailyTask/domain/entities/daily_task_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyTaskFormCubit extends Cubit<DailyTaskFormReq> {
  DailyTaskFormCubit()
    : super(DailyTaskFormReq.initialWithStartIn(const Duration(minutes: 10)));

  // ===== Basic setters =====
  void setDailyTaskId(String v) => emit(state.copyWith(dailyTaskId: v));
  void setTitle(String v) => emit(state.copyWith(title: v));
  void setDescription(String v) => emit(state.copyWith(description: v));

  // ===== Project info =====
  void setProjectName(String v) => emit(state.copyWith(projectName: v));
  void setProjectRef(bool v) => emit(state.copyWith(projectReference: v));
  void setProjectDescription(String v) =>
      emit(state.copyWith(projectDescription: v));
  void setProjectCategory(String v) => emit(state.copyWith(projectCategory: v));
  void setProjectModel(String v) => emit(state.copyWith(projectModel: v));
  void setCustomerCompany(String v) => emit(state.copyWith(customerCompany: v));

  // ===== Date & time =====
  void setDate(DateTime? d) => emit(state.copyWith(date: d));
  void setStartTime(TimeOfDay? t) => emit(state.copyWith(startTime: t));
  void setEndTime(TimeOfDay? t) => emit(state.copyWith(endTime: t));

  /// Convenience: set sekaligus
  void setDateAndTimes({DateTime? date, TimeOfDay? start, TimeOfDay? end}) {
    emit(
      state.copyWith(
        date: date ?? state.date,
        startTime: start ?? state.startTime,
        endTime: end ?? state.endTime,
      ),
    );
  }

  // ===== Participants & Category =====
  void setTaskCategory(TypeCategorySelectionEntity? v) =>
      emit(state.copyWith(dailyTaskCategory: v));

  void clearTaskCategory() => emit(state.copyWith(dailyTaskCategory: null));

  void setParticipants(List<StaffEntity> list) => emit(
    state.copyWith(listParticipant: List<StaffEntity>.unmodifiable(list)),
  );

  /// Toggle add/remove participant by staffId
  void toggleParticipantByEntity(StaffEntity m) {
    final exists = state.listParticipant.any((e) => e.staffId == m.staffId);
    final updated = exists
        ? state.listParticipant.where((e) => e.staffId != m.staffId).toList()
        : [...state.listParticipant, m];

    emit(
      state.copyWith(listParticipant: List<StaffEntity>.unmodifiable(updated)),
    );
  }

  // ===== Reset ke nilai awal =====
  void reset() => emit(const DailyTaskFormReq());

  /// Helper: ambil hanya tanggal (00:00)
  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Helper: Timestamp? -> TimeOfDay?
  TimeOfDay? _toTimeOfDay(Timestamp? t) {
    if (t == null) return null;
    final dt = t.toDate();
    return TimeOfDay(hour: dt.hour, minute: dt.minute);
  }

  /// Isi form dari DailyTaskEntity
  void hydrateFromEntity(DailyTaskEntity e) {
    final guessedDate = e.startTime?.toDate();
    emit(
      state.copyWith(
        dailyTaskId: e.dailyTaskId,
        title: e.title,
        description: e.description,
        projectName: e.projectName,
        projectDescription: e.projectDescription,
        projectCategory: e.projectCategory,
        projectModel: e.projectModel,
        customerCompany: e.customerCompany,
        date: guessedDate != null ? _dateOnly(guessedDate) : state.date,
        startTime: _toTimeOfDay(e.startTime),
        endTime: _toTimeOfDay(e.endTime),
        listParticipant: e.listParticipant,
        dailyTaskCategory: e.dailyTaskCategory,
        projectReference: e.projectName != '' ? true : false,
      ),
    );
  }
}
