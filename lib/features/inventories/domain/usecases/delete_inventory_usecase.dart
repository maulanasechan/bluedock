import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class DeleteInventoryUseCase implements UseCase<Either, InventoryEntity> {
  @override
  Future<Either> call({InventoryEntity? params}) async {
    return await sl<InventoryRepository>().deleteInventory(params!);
  }
}
