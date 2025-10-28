import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/inventories/data/models/search_inventory_req.dart';
import 'package:bluedock/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SearchInventoryUseCase implements UseCase<Either, SearchInventoryReq> {
  @override
  Future<Either> call({SearchInventoryReq? params}) async {
    return await sl<InventoryRepository>().searchInventory(params!);
  }
}
