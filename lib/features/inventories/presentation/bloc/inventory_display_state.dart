import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';

abstract class InventoryDisplayState {}

class InventoryDisplayInitial extends InventoryDisplayState {}

class InventoryDisplayLoading extends InventoryDisplayState {}

class InventoryDisplayFetched extends InventoryDisplayState {
  final List<InventoryEntity> listInventory;
  InventoryDisplayFetched({required this.listInventory});
}

class InventoryDisplayFailure extends InventoryDisplayState {
  final String message;
  InventoryDisplayFailure({required this.message});
}

class InventoryDisplayOneFetched extends InventoryDisplayState {
  final InventoryEntity inventory;
  InventoryDisplayOneFetched({required this.inventory});
}
