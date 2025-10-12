import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyTaskEntity {
  final String dailyTaskId;
  final String title;
  final String description;

  final String projectName;
  final String projectDescription;
  final String projectCategory;
  final String projectModel;
  final String customerCompany;

  final Timestamp? startTime;
  final Timestamp? endTime;
  final Timestamp? date;

  final List<StaffEntity> listParticipant;
  final TypeCategorySelectionEntity dailyTaskCategory;

  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;

  DailyTaskEntity({
    required this.dailyTaskId,
    required this.title,
    required this.description,

    required this.projectName,
    required this.projectDescription,
    required this.projectCategory,
    required this.projectModel,
    required this.customerCompany,

    required this.startTime,
    required this.endTime,
    required this.date,

    required this.listParticipant,
    required this.dailyTaskCategory,
    required this.updatedAt,
    required this.createdAt,
    required this.createdBy,
  });

  DailyTaskEntity copyWith({
    String? dailyTaskId,
    String? title,
    String? description,
    String? projectName,
    String? projectDescription,
    String? projectCategory,
    String? projectModel,
    String? customerCompany,
    Timestamp? date,
    Timestamp? startTime,
    Timestamp? endTime,
    List<StaffEntity>? listParticipant,
    TypeCategorySelectionEntity? dailyTaskCategory,
    Timestamp? updatedAt,
    Timestamp? createdAt,
    String? createdBy,
  }) {
    return DailyTaskEntity(
      dailyTaskId: dailyTaskId ?? this.dailyTaskId,
      title: title ?? this.title,
      description: description ?? this.description,
      projectName: projectName ?? this.projectName,
      projectDescription: projectDescription ?? this.projectDescription,
      projectCategory: projectCategory ?? this.projectCategory,
      projectModel: projectModel ?? this.projectModel,
      customerCompany: customerCompany ?? this.customerCompany,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      listParticipant: listParticipant ?? this.listParticipant,
      dailyTaskCategory: dailyTaskCategory ?? this.dailyTaskCategory,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
