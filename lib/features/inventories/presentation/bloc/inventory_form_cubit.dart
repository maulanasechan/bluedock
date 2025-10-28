import 'package:bluedock/features/inventories/data/models/inventory_form_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';

class InventoryFormCubit extends Cubit<InventoryFormReq> {
  InventoryFormCubit() : super(const InventoryFormReq());

  // ===== String fields =====
  void setInventoryId(String v) => emit(state.copyWith(inventoryId: v));
  void setStockName(String v) => emit(state.copyWith(stockName: v));
  void setCurrency(String v) => emit(state.copyWith(currency: v));
  void setPartNo(String v) => emit(state.copyWith(partNo: v));
  void setUpdatedBy(String v) => emit(state.copyWith(updatedBy: v));
  void setCreatedBy(String v) => emit(state.copyWith(createdBy: v));

  // ===== Numeric fields =====
  void setPrice(int? v) => emit(state.copyWith(price: v));
  void setPriceFromText(String v) =>
      emit(state.copyWith(price: int.tryParse(v)));

  void setQuantity(int v) => emit(state.copyWith(quantity: v));
  void setQuantityFromText(String v) =>
      emit(state.copyWith(quantity: int.tryParse(v) ?? 0));

  void setNeedMaintenance(bool v) => emit(state.copyWith(needMaintenance: v));

  void setDeliveryQuantity(int v) => emit(state.copyWith(deliveryQuantity: v));
  void setDeliveryQuantityFromText(String v) =>
      emit(state.copyWith(deliveryQuantity: int.tryParse(v) ?? 0));
  void setMaintenancePeriod(int? v) =>
      emit(state.copyWith(maintenancePeriod: v));
  void setMaintenanceCurrency(String v) =>
      emit(state.copyWith(maintenanceCurrency: v));

  // ===== Date/Time =====
  void setArrivalDate(Timestamp? t) => emit(state.copyWith(arrivalDate: t));
  void setUpdatedAt(Timestamp? t) => emit(state.copyWith(updatedAt: t));
  void setCreatedAt(Timestamp? t) => emit(state.copyWith(createdAt: t));

  // ===== Relations =====
  void setProductCategory(ProductCategoryEntity v) =>
      emit(state.copyWith(productCategory: v));

  void setProductSelection(ProductSelectionEntity v) =>
      emit(state.copyWith(productSelection: v));

  // ===== Favorites (opsional; kalau kamu kelola di form) =====
  void addFavorite(String uid) {
    if (state.favorites.contains(uid)) return;
    emit(
      state.copyWith(
        favorites: List<String>.unmodifiable([...state.favorites, uid]),
      ),
    );
  }

  void removeFavorite(String uid) {
    if (!state.favorites.contains(uid)) return;
    emit(
      state.copyWith(
        favorites: List<String>.unmodifiable(
          state.favorites.where((e) => e != uid),
        ),
      ),
    );
  }

  // ===== Hydrate dari Entity (prefill untuk edit) =====
  void hydrateFromEntity(InventoryEntity e) {
    emit(
      InventoryFormReq(
        inventoryId: e.inventoryId,
        stockName: e.stockName,
        productCategory: e.productCategory,
        productSelection: e.productSelection,
        price: e.price,
        currency: e.currency,
        quantity: e.quantity,
        deliveryQuantity: e.deliveryQuantity,
        partNo: e.partNo,
        arrivalDate: e.arrivalDate,
        favorites: e.favorites,
        updatedAt: e.updatedAt,
        updatedBy: e.updatedBy,
        createdAt: e.createdAt,
        createdBy: e.createdBy,
      ),
    );
  }

  // ===== Reset ke nilai awal =====
  void reset() => emit(const InventoryFormReq());
}
