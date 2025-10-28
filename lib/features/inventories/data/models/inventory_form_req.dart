import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';

class InventoryFormReq {
  final String inventoryId;
  final String stockName;
  final ProductCategoryEntity? productCategory;
  final ProductSelectionEntity? productSelection;
  final int? maintenancePeriod;
  final String maintenanceCurrency;

  final int? price;
  final String currency;
  final int quantity;
  final int deliveryQuantity;
  final String partNo;
  final Timestamp? arrivalDate;

  final List<String> favorites;
  final bool needMaintenance;

  // metadata
  final Timestamp? updatedAt;
  final String updatedBy;
  final Timestamp? createdAt;
  final String createdBy;

  const InventoryFormReq({
    this.inventoryId = '',
    this.stockName = '',
    this.productCategory,
    this.productSelection,
    this.price,
    this.currency = 'USD',
    this.quantity = 0,
    this.deliveryQuantity = 0,
    this.partNo = '',
    this.arrivalDate,
    this.favorites = const <String>[],
    this.needMaintenance = true,
    this.maintenancePeriod,
    this.maintenanceCurrency = 'Hours',
    this.updatedAt,
    this.updatedBy = '',
    this.createdAt,
    this.createdBy = '',
  });

  InventoryFormReq copyWith({
    String? inventoryId,
    String? stockName,
    ProductCategoryEntity? productCategory,
    ProductSelectionEntity? productSelection,
    int? price,
    String? currency,
    int? quantity,
    int? deliveryQuantity,
    String? partNo,
    Timestamp? arrivalDate,
    List<String>? favorites,
    Timestamp? updatedAt,
    String? updatedBy,
    Timestamp? createdAt,
    String? createdBy,
    int? maintenancePeriod,
    String? maintenanceCurrency,
    bool? needMaintenance,
  }) {
    return InventoryFormReq(
      inventoryId: inventoryId ?? this.inventoryId,
      stockName: stockName ?? this.stockName,
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      deliveryQuantity: deliveryQuantity ?? this.deliveryQuantity,
      partNo: partNo ?? this.partNo,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      maintenancePeriod: maintenancePeriod ?? this.maintenancePeriod,
      maintenanceCurrency: maintenanceCurrency ?? this.maintenanceCurrency,
      favorites: favorites ?? this.favorites,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      needMaintenance: needMaintenance ?? this.needMaintenance,
    );
  }
}
