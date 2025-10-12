import 'package:bluedock/common/domain/entities/item_selection_entity.dart';

class ItemSelectionModel {
  final String selectionId;
  final String title;
  ItemSelectionModel({required this.selectionId, required this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'selectionId': selectionId, 'title': title};
  }

  factory ItemSelectionModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('ProductModel.fromMap: map is null');
    }

    final String selectionId =
        (map['SelectionId'] ?? map['SelectionId'] ?? '') as String;

    return ItemSelectionModel(
      selectionId: selectionId,
      title: (map['title'] ?? '') as String,
    );
  }
}

extension ItemSelectionXModel on ItemSelectionModel {
  ItemSelectionEntity toEntity() {
    return ItemSelectionEntity(selectionId: selectionId, title: title);
  }
}
