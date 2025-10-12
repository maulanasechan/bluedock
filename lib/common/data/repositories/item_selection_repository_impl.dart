import 'package:bluedock/common/data/models/itemSelection/item_selection_model.dart';
import 'package:bluedock/common/data/models/itemSelection/item_selection_req.dart';
import 'package:bluedock/common/data/models/itemSelection/type_category_selection_model.dart';
import 'package:bluedock/common/data/sources/item_selection_firebase_service.dart';
import 'package:bluedock/common/domain/repositories/item_selection_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class ItemSelectionRepositoryImpl extends ItemSelectionRepository {
  @override
  Future<Either> getItemSelection(ItemSelectionReq selection) async {
    var returnedData = await sl<ItemSelectionFirebaseService>()
        .getItemSelection(selection);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ItemSelectionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getTypeCategorySelection(ItemSelectionReq selection) async {
    var returnedData = await sl<ItemSelectionFirebaseService>()
        .getItemSelection(selection);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => TypeCategorySelectionModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }
}
