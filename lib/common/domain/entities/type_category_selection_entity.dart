class TypeCategorySelectionEntity {
  final String selectionId;
  final String title;
  final String image;
  final String color;

  const TypeCategorySelectionEntity({
    required this.selectionId,
    required this.title,
    required this.image,
    required this.color,
  });

  factory TypeCategorySelectionEntity.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      // dokumen lama: kategori belum diisi
      return const TypeCategorySelectionEntity(
        selectionId: '',
        title: '',
        image: '',
        color: '',
      );
    }
    return TypeCategorySelectionEntity(
      selectionId: (json['selectionId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      image: (json['image'] as String?) ?? '',
      color: (json['color'] as String?) ?? '',
    );
  }

  factory TypeCategorySelectionEntity.fromMap(Map<String, dynamic>? map) {
    // Firestore umumnya kasih Map<String, dynamic>, tapi tetap amanin null
    if (map == null || map.isEmpty) {
      return const TypeCategorySelectionEntity(
        selectionId: '',
        title: '',
        image: '',
        color: '',
      );
    }
    return TypeCategorySelectionEntity(
      selectionId: (map['selectionId'] as String?) ?? '',
      title: (map['title'] as String?) ?? '',
      image: (map['image'] as String?) ?? '',
      color: (map['color'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'selectionId': selectionId,
    'title': title,
    'image': image,
    'color': color,
  };

  TypeCategorySelectionEntity copyWith({
    String? selectionId,
    String? title,
    String? image,
    String? color,
  }) {
    return TypeCategorySelectionEntity(
      selectionId: selectionId ?? this.selectionId,
      title: title ?? this.title,
      image: image ?? this.image,
      color: color ?? this.color,
    );
  }
}
