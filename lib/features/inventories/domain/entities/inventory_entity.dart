import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryEntity {
  final String inventoryId;
  final String stockName;

  final ProductCategoryEntity productCategory;
  final ProductSelectionEntity productSelection;

  final int price;
  final String currency;
  final String image;

  final int quantity;
  final int deliveryQuantity;

  final List<String> favorites;

  final String partNo;
  final Timestamp? arrivalDate;

  final String maintenanceCurrency;
  final int? maintenancePeriod;

  final Timestamp? updatedAt;
  final String updatedBy;

  final Timestamp createdAt;
  final String createdBy;

  InventoryEntity({
    required this.inventoryId,
    required this.productCategory,
    required this.productSelection,
    required this.stockName,
    required this.image,
    required this.price,
    required this.currency,
    required this.quantity,
    required this.deliveryQuantity,
    required this.partNo,
    required this.arrivalDate,
    required this.maintenanceCurrency,
    required this.maintenancePeriod,
    required this.favorites,
    required this.updatedAt,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
  });

  InventoryEntity copyWith({
    String? inventoryId,
    String? stockName,
    String? image,
    ProductCategoryEntity? productCategory,
    ProductSelectionEntity? productSelection,
    int? price,
    String? currency,
    int? quantity,
    int? deliveryQuantity,
    int? maintenancePeriod,
    String? maintenanceCurrency,
    List<String>? favorites,
    String? partNo,
    Timestamp? arrivalDate,
    Timestamp? updatedAt,
    String? updatedBy,
    Timestamp? createdAt,
    String? createdBy,
  }) {
    return InventoryEntity(
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
      arrivalDate: arrivalDate ?? this.arrivalDate,
      maintenanceCurrency: maintenanceCurrency ?? this.maintenanceCurrency,
      maintenancePeriod: maintenancePeriod ?? this.maintenancePeriod,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'inventoryId': inventoryId,
      'stockName': stockName,
      'image': image,
      'productCategory': productCategory.toJson(),
      'productSelection': productSelection.toJson(),
      'price': price,
      'currency': currency,
      'quantity': quantity,
      'deliveryQuantity': deliveryQuantity,
      'favorites': favorites,
      'partNo': partNo,
      'arrivalDate': arrivalDate,
      'maintenanceCurrency': maintenanceCurrency,
      'maintenancePeriod': maintenancePeriod,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };

    // buang field bernilai null agar rapi di Firestore
    map.removeWhere((_, v) => v == null);
    return map;
  }

  factory InventoryEntity.fromJson(Map<String, dynamic> json) {
    List<String> asStringList(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : const <String>[];

    final productCategoryMap =
        (json['productCategory'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final productSelectionMap =
        (json['productSelection'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};

    final createdAtValue = json['createdAt'];
    final updatedAtValue = json['updatedAt'];
    final arrivalDateValue = json['arrivalDate'];

    return InventoryEntity(
      inventoryId: (json['inventoryId'] ?? '') as String,
      stockName: (json['stockName'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      productCategory: ProductCategoryEntity.fromJson(productCategoryMap),
      productSelection: ProductSelectionEntity.fromJson(productSelectionMap),
      price: _asInt(json['price']),
      currency: (json['currency'] ?? '') as String,
      quantity: _asInt(json['quantity']),
      deliveryQuantity: _asInt(json['deliveryQuantity']),
      favorites: asStringList(json['favorites']),
      partNo: (json['partNo'] ?? '') as String,
      arrivalDate: arrivalDateValue is Timestamp ? arrivalDateValue : null,
      maintenanceCurrency: (json['maintenanceCurrency'] ?? '') as String,
      maintenancePeriod: _asIntNullable(json['maintenancePeriod']),
      updatedAt: updatedAtValue is Timestamp ? updatedAtValue : null,
      updatedBy: (json['updatedBy'] ?? '') as String,
      createdAt: createdAtValue is Timestamp ? createdAtValue : Timestamp.now(),
      createdBy: (json['createdBy'] ?? '') as String,
    );
  }

  factory InventoryEntity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return InventoryEntity.fromJson({
      'inventoryId': data['inventoryId'] ?? doc.id,
      ...data,
    });
  }

  // --- Helpers ---

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
    // catatan: sesuaikan bila butuh strict error
  }

  static int? _asIntNullable(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}
