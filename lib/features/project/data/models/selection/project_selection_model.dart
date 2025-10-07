import 'package:bluedock/features/project/domain/entities/selection/project_selection_entity.dart';

class ProjectSelectionModel {
  final String selectionId;
  final String title;
  ProjectSelectionModel({required this.selectionId, required this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'selectionId': selectionId, 'title': title};
  }

  factory ProjectSelectionModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('ProductModel.fromMap: map is null');
    }

    final String selectionId =
        (map['SelectionId'] ?? map['SelectionId'] ?? '') as String;

    return ProjectSelectionModel(
      selectionId: selectionId,
      title: (map['title'] ?? '') as String,
    );
  }
}

extension ProjectSelectionXModel on ProjectSelectionModel {
  ProjectSelectionEntity toEntity() {
    return ProjectSelectionEntity(selectionId: selectionId, title: title);
  }
}
