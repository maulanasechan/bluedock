import 'package:bluedock/common/domain/entities/item_selection_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';

abstract class ItemSelectionDisplayState {}

class ItemSelectionDisplayLoading extends ItemSelectionDisplayState {}

class ItemSelectionDisplayFetched extends ItemSelectionDisplayState {
  final List<ItemSelectionEntity> listSelection;

  ItemSelectionDisplayFetched({required this.listSelection});
}

class ItemSelectionDisplayFailure extends ItemSelectionDisplayState {
  final String message;

  ItemSelectionDisplayFailure({required this.message});
}

class TypeCategorySelectionDisplayFetched extends ItemSelectionDisplayState {
  final List<TypeCategorySelectionEntity> listSelection;

  TypeCategorySelectionDisplayFetched({required this.listSelection});
}
