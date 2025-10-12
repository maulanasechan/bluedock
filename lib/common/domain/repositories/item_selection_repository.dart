import 'package:bluedock/common/data/models/itemSelection/item_selection_req.dart';
import 'package:dartz/dartz.dart';

abstract class ItemSelectionRepository {
  Future<Either> getItemSelection(ItemSelectionReq selection);
  Future<Either> getTypeCategorySelection(ItemSelectionReq selection);
}
