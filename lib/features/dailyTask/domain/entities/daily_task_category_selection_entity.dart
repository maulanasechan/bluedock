class DailyTaskCategorySelectionEntity {
  final String selectionId;
  final String title;
  final String image;

  const DailyTaskCategorySelectionEntity({
    required this.selectionId,
    required this.title,
    required this.image,
  });

  DailyTaskCategorySelectionEntity copyWith({
    String? selectionId,
    String? title,
    String? image,
  }) {
    return DailyTaskCategorySelectionEntity(
      selectionId: selectionId ?? this.selectionId,
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() => {
    'selectionId': selectionId,
    'title': title,
    'image': image,
  };

  factory DailyTaskCategorySelectionEntity.fromJson(Map<String, dynamic> json) {
    return DailyTaskCategorySelectionEntity(
      selectionId: json['selectionId'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
    );
  }

  factory DailyTaskCategorySelectionEntity.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('Selection model: map is null');
    }

    final String selectionId =
        (map['selectionId'] ?? map['selectionId'] ?? '') as String;

    return DailyTaskCategorySelectionEntity(
      selectionId: selectionId,
      title: (map['title'] ?? '') as String,
      image: (map['image'] ?? '') as String,
    );
  }
}
