import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class FavoriteInventoryUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<InventoryRepository>().favoriteInventory(params!);
  }
}
