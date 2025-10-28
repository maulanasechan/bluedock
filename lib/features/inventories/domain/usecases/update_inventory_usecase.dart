import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/inventories/data/models/inventory_form_req.dart';
import 'package:bluedock/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateInventoryUseCase implements UseCase<Either, InventoryFormReq> {
  @override
  Future<Either> call({InventoryFormReq? params}) async {
    return await sl<InventoryRepository>().updateInventory(params!);
  }
}
