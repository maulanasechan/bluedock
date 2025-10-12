import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';

class TypeCategorySelectionModel {
  final String selectionId;
  final String title;
  final String image;
  final String color;

  TypeCategorySelectionModel({
    required this.selectionId,
    required this.title,
    required this.image,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectionId': selectionId,
      'title': title,
      'image': image,
      'color': color,
    };
  }

  factory TypeCategorySelectionModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('ProductModel.fromMap: map is null');
    }

    final String selectionId =
        (map['SelectionId'] ?? map['SelectionId'] ?? '') as String;

    return TypeCategorySelectionModel(
      selectionId: selectionId,
      title: (map['title'] ?? '') as String,
      image: (map['image'] ?? '') as String,
      color: (map['color'] ?? '') as String,
    );
  }
}

extension TypeCategorySelectionXModel on TypeCategorySelectionModel {
  TypeCategorySelectionEntity toEntity() {
    return TypeCategorySelectionEntity(
      selectionId: selectionId,
      title: title,
      image: image,
      color: color,
    );
  }
}
