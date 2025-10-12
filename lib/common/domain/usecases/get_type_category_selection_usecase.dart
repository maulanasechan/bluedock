import 'package:bluedock/common/domain/repositories/item_selection_repository.dart';
import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/common/data/models/itemSelection/item_selection_req.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetTypeCategorySelectionUseCase
    implements UseCase<Either, ItemSelectionReq> {
  @override
  Future<Either> call({ItemSelectionReq? params}) async {
    return await sl<ItemSelectionRepository>().getTypeCategorySelection(
      params!,
    );
  }
}
