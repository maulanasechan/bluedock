import 'dart:convert';
import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluedock/features/dailyTask/domain/entities/daily_task_entity.dart';

class DailyTaskModel {
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

  const DailyTaskModel({
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

  DailyTaskModel copyWith({
    String? dailyTaskId,
    String? title,
    String? description,
    String? projectName,
    String? projectDescription,
    String? projectCategory,
    String? projectModel,
    String? customerCompany,
    Timestamp? startTime,
    Timestamp? endTime,
    Timestamp? date,
    List<StaffEntity>? listParticipant,
    TypeCategorySelectionEntity? dailyTaskCategory,
    Timestamp? updatedAt,
    Timestamp? createdAt,
    String? createdBy,
  }) {
    return DailyTaskModel(
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dailyTaskId': dailyTaskId,
      'title': title,
      'description': description,
      'projectName': projectName,
      'projectDescription': projectDescription,
      'projectCategory': projectCategory,
      'projectModel': projectModel,
      'customerCompany': customerCompany,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'listParticipant': listParticipant.map((e) => e.toJson()).toList(),
      'dailyTaskCategory': dailyTaskCategory.toJson(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }

  factory DailyTaskModel.fromMap(Map<String, dynamic> map) {
    return DailyTaskModel(
      dailyTaskId: (map['dailyTaskId'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      projectName: (map['projectName'] ?? '') as String,
      projectDescription: (map['projectDescription'] ?? '') as String,
      projectCategory: (map['projectCategory'] ?? '') as String,
      projectModel: (map['projectModel'] ?? '') as String,
      customerCompany: (map['customerCompany'] ?? '') as String,
      startTime: map['startTime'] as Timestamp?,
      endTime: map['endTime'] as Timestamp?,
      date: map['date'] as Timestamp?,
      listParticipant: (map['listParticipant'] is List)
          ? (map['listParticipant'] as List)
                .map(
                  (e) =>
                      StaffEntity.fromJson(Map<String, dynamic>.from(e as Map)),
                )
                .toList()
          : const <StaffEntity>[],
      dailyTaskCategory: TypeCategorySelectionEntity.fromJson(
        (map['dailyTaskCategory'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      updatedAt: map['updatedAt'] as Timestamp?,
      createdAt: map['createdAt'] is Timestamp
          ? map['createdAt'] as Timestamp
          : Timestamp(0, 0),
      createdBy: (map['createdBy'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyTaskModel.fromJson(String source) =>
      DailyTaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension DailyTaskXModel on DailyTaskModel {
  DailyTaskEntity toEntity() {
    return DailyTaskEntity(
      dailyTaskId: dailyTaskId,
      title: title,
      description: description,
      projectName: projectName,
      projectDescription: projectDescription,
      projectCategory: projectCategory,
      projectModel: projectModel,
      customerCompany: customerCompany,
      startTime: startTime,
      endTime: endTime,
      date: date,
      listParticipant: listParticipant,
      dailyTaskCategory: dailyTaskCategory,
      updatedAt: updatedAt,
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }
}
