import 'package:bluedock/features/product/domain/entities/selection_entity.dart';

class SelectionModel {
  final String selectionId;
  final String title;
  SelectionModel({required this.selectionId, required this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'selectionId': selectionId, 'title': title};
  }

  factory SelectionModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('ProductModel.fromMap: map is null');
    }

    final String selectionId =
        (map['SelectionId'] ?? map['SelectionId'] ?? '') as String;

    return SelectionModel(
      selectionId: selectionId,
      title: (map['title'] ?? '') as String,
    );
  }
}

extension SelectionXModel on SelectionModel {
  SelectionEntity toEntity() {
    return SelectionEntity(selectionId: selectionId, title: title);
  }
}
