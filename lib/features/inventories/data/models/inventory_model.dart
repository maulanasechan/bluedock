import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluedock/common/data/models/productCategory/product_category_model.dart';
import 'package:bluedock/common/data/models/product/product_selection_model.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';

class InventoryModel {
  final String inventoryId;
  final String stockName;
  final String image;
  final ProductCategoryModel productCategory;
  final ProductSelectionModel productSelection;

  final int price;
  final String currency;
  final int quantity;
  final int deliveryQuantity;
  final List<String> favorites;
  final String partNo;
  final int? maintenancePeriod;
  final String maintenanceCurrency;
  final Timestamp? arrivalDate;

  final Timestamp? updatedAt;
  final String updatedBy;
  final Timestamp createdAt;
  final String createdBy;

  const InventoryModel({
    required this.inventoryId,
    required this.stockName,
    required this.image,
    required this.productCategory,
    required this.productSelection,
    required this.price,
    required this.currency,
    required this.quantity,
    required this.deliveryQuantity,
    required this.favorites,
    required this.partNo,
    required this.maintenanceCurrency,
    required this.maintenancePeriod,
    required this.arrivalDate,
    required this.updatedAt,
    required this.updatedBy,
    required this.createdAt,
    required this.createdBy,
  });

  InventoryModel copyWith({
    String? inventoryId,
    String? stockName,
    String? image,
    ProductCategoryModel? productCategory,
    ProductSelectionModel? productSelection,
    int? price,
    String? currency,
    int? quantity,
    int? deliveryQuantity,
    List<String>? favorites,
    String? partNo,
    String? maintenanceCurrency,
    int? maintenancePeriod,
    Timestamp? arrivalDate,
    Timestamp? updatedAt,
    String? updatedBy,
    Timestamp? createdAt,
    String? createdBy,
  }) {
    return InventoryModel(
      inventoryId: inventoryId ?? this.inventoryId,
      stockName: stockName ?? this.stockName,
      image: image ?? this.image,
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      deliveryQuantity: deliveryQuantity ?? this.deliveryQuantity,
      favorites: favorites ?? this.favorites,
      partNo: partNo ?? this.partNo,
      maintenanceCurrency: maintenanceCurrency ?? this.maintenanceCurrency,
      maintenancePeriod: maintenancePeriod ?? this.maintenancePeriod,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'inventoryId': inventoryId,
      'stockName': stockName,
      'image': image,
      'productCategory': productCategory.toMap(),
      'productSelection': productSelection.toMap(),
      'price': price,
      'currency': currency,
      'quantity': quantity,
      'deliveryQuantity': deliveryQuantity,
      'favorites': favorites,
      'partNo': partNo,
      'maintenanceCurrency': maintenanceCurrency,
      'maintenancePeriod': maintenancePeriod,
      'arrivalDate': arrivalDate,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }

  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    int asInt(dynamic v, {int def = 0}) {
      if (v is int) return v;
      if (v is double) return v.round();
      if (v is num) return v.toInt();
      if (v is String) {
        final p = int.tryParse(v);
        if (p != null) return p;
      }
      return def;
    }

    List<String> asStringList(dynamic v) {
      if (v is List) return v.map((e) => e.toString()).toList();
      return const <String>[];
    }

    return InventoryModel(
      inventoryId: (map['inventoryId'] ?? '') as String,
      stockName: (map['stockName'] ?? '') as String,
      image: (map['image'] ?? '') as String,
      productCategory: ProductCategoryModel.fromMap(
        (map['productCategory'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      productSelection: ProductSelectionModel.fromMap(
        (map['productSelection'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      price: asInt(map['price']),
      currency: (map['currency'] ?? '') as String,
      quantity: asInt(map['quantity']),
      deliveryQuantity: asInt(map['deliveryQuantity']),
      favorites: asStringList(map['favorites']),
      partNo: (map['partNo'] ?? '') as String,
      maintenanceCurrency: (map['maintenanceCurrency'] ?? '') as String,
      maintenancePeriod: asInt(map['maintenancePeriod']),
      arrivalDate: map['arrivalDate'],
      updatedAt: map['updatedAt'],
      updatedBy: (map['updatedBy'] ?? '') as String,
      createdAt: map['createdAt'] ?? Timestamp(0, 0),
      createdBy: (map['createdBy'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryModel.fromJson(String source) =>
      InventoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension InventoryXModel on InventoryModel {
  InventoryEntity toEntity() {
    return InventoryEntity(
      inventoryId: inventoryId,
      stockName: stockName,
      image: image,
      productCategory: productCategory.toEntity(),
      productSelection: productSelection.toEntity(),
      price: price,
      currency: currency,
      quantity: quantity,
      deliveryQuantity: deliveryQuantity,
      favorites: favorites,
      partNo: partNo,
      maintenanceCurrency: maintenanceCurrency,
      maintenancePeriod: maintenancePeriod,
      arrivalDate: arrivalDate,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }
}
