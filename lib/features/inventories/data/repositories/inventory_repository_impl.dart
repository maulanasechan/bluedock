import 'package:bluedock/features/inventories/data/models/inventory_form_req.dart';
import 'package:bluedock/features/inventories/data/models/inventory_model.dart';
import 'package:bluedock/features/inventories/data/models/search_inventory_req.dart';
import 'package:bluedock/features/inventories/data/sources/inventory_firebase_service.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class InventoryRepositoryImpl extends InventoryRepository {
  @override
  Future<Either> searchInventory(SearchInventoryReq query) async {
    final res = await sl<InventoryFirebaseService>().searchInventory(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(
          data,
        ).map((e) => InventoryModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> getInventoryById(String inventoryId) async {
    final res = await sl<InventoryFirebaseService>().getInventoryById(
      inventoryId,
    );
    return res.fold(
      (err) => Left(err),
      (m) => Right(InventoryModel.fromMap(m).toEntity()),
    );
  }

  @override
  Future<Either> addInventory(InventoryFormReq inventory) async {
    return await sl<InventoryFirebaseService>().addInventory(inventory);
  }

  @override
  Future<Either> updateInventory(InventoryFormReq inventory) async {
    return await sl<InventoryFirebaseService>().updateInventory(inventory);
  }

  @override
  Future<Either> deleteInventory(InventoryEntity req) async {
    return await sl<InventoryFirebaseService>().deleteInventory(req);
  }

  @override
  Future<Either> favoriteInventory(String req) async {
    return await sl<InventoryFirebaseService>().favoriteInventory(req);
  }
}
