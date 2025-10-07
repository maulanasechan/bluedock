class ProjectSelectionEntity {
  final String selectionId;
  final String title;
  ProjectSelectionEntity({required this.selectionId, required this.title});

  Map<String, dynamic> toJson() => {'selectionId': selectionId, 'title': title};

  factory ProjectSelectionEntity.fromJson(Map<String, dynamic> json) {
    return ProjectSelectionEntity(
      selectionId: json['selectionId'] as String,
      title: json['title'] as String,
    );
  }

  factory ProjectSelectionEntity.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('Selection model: map is null');
    }

    final String selectionId =
        (map['selectionId'] ?? map['selectionId'] ?? '') as String;

    return ProjectSelectionEntity(
      selectionId: selectionId,
      title: (map['title'] ?? '') as String,
    );
  }
}
