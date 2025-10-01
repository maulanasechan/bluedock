class SelectionEntity {
  final String selectionId;
  final String title;
  SelectionEntity({required this.selectionId, required this.title});

  Map<String, dynamic> toJson() => {'selectionId': selectionId, 'title': title};

  factory SelectionEntity.fromJson(Map<String, dynamic> json) {
    return SelectionEntity(
      selectionId: json['selectionId'] as String,
      title: json['title'] as String,
    );
  }

  factory SelectionEntity.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('Selection model: map is null');
    }

    final String selectionId =
        (map['selectionId'] ?? map['selectionId'] ?? '') as String;

    return SelectionEntity(
      selectionId: selectionId,
      title: (map['title'] ?? '') as String,
    );
  }
}
