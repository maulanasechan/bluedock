class ItemSelectionEntity {
  final String selectionId;
  final String title;
  ItemSelectionEntity({required this.selectionId, required this.title});

  Map<String, dynamic> toJson() => {'selectionId': selectionId, 'title': title};

  factory ItemSelectionEntity.fromJson(Map<String, dynamic> json) {
    return ItemSelectionEntity(
      selectionId: json['selectionId'] as String,
      title: json['title'] as String,
    );
  }

  factory ItemSelectionEntity.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('Selection model: map is null');
    }

    final String selectionId =
        (map['selectionId'] ?? map['selectionId'] ?? '') as String;

    return ItemSelectionEntity(
      selectionId: selectionId,
      title: (map['title'] ?? '') as String,
    );
  }
}
