import 'package:bluedock/features/inventories/data/models/inventory_form_req.dart';
import 'package:bluedock/features/inventories/data/models/search_inventory_req.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:dartz/dartz.dart';

abstract class InventoryRepository {
  Future<Either> addInventory(InventoryFormReq req);
  Future<Either> updateInventory(InventoryFormReq req);
  Future<Either> deleteInventory(InventoryEntity req);
  Future<Either> favoriteInventory(String req);
  Future<Either> searchInventory(SearchInventoryReq req);
  Future<Either> getInventoryById(String req);
}
