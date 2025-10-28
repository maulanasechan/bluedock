import 'dart:convert';
import 'package:bluedock/common/data/models/project/project_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bluedock/features/inventories/data/models/inventory_model.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';

import 'package:bluedock/common/data/models/productCategory/product_category_model.dart';
import 'package:bluedock/common/data/models/product/product_selection_model.dart';
import 'package:bluedock/common/data/models/itemSelection/type_category_selection_model.dart';

class PurchaseOrderModel {
  // IDs & linkage
  final String purchaseOrderId;
  final ProjectModel? project;
  final String poName;

  // Project & contract
  final String currency;
  final int? price;

  // Quantity
  final List<int> quantity;

  // Seller
  final String sellerName;
  final String sellerCompany;
  final String sellerContact;

  // Selections
  final ProductCategoryModel? productCategory;
  final ProductSelectionModel? productSelection;

  // Components
  final List<InventoryModel> listComponent;

  // Meta
  final List<String> searchKeywords;
  final List<String> favorites;
  final TypeCategorySelectionModel type;
  final String status; // ← added

  // Audit
  final String createdBy;
  final Timestamp createdAt;
  final String? updatedBy;
  final Timestamp? updatedAt;

  const PurchaseOrderModel({
    // IDs & linkage
    required this.purchaseOrderId,
    this.project,
    this.poName = '',

    // Project & contract
    required this.currency,
    this.price,

    // Quantity
    required this.quantity,

    // Seller
    this.sellerName = '',
    this.sellerCompany = '',
    this.sellerContact = '',

    // Selections
    this.productCategory,
    this.productSelection,

    // Components
    this.listComponent = const <InventoryModel>[],

    // Meta
    this.searchKeywords = const <String>[],
    this.favorites = const <String>[],
    required this.type,
    this.status = 'Active', // ← default
    // Audit
    required this.createdBy,
    required this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  PurchaseOrderModel copyWith({
    // IDs & linkage
    String? purchaseOrderId,
    ProjectModel? project,
    String? poName,

    // Project & contract
    String? currency,
    Object? price = _unset,
    List<int>? quantity,

    // Seller
    String? sellerName,
    String? sellerCompany,
    String? sellerContact,

    // Selections
    ProductCategoryModel? productCategory,
    ProductSelectionModel? productSelection,

    // Components
    List<InventoryModel>? listComponent,

    // Meta
    List<String>? searchKeywords,
    List<String>? favorites,
    TypeCategorySelectionModel? type,
    String? status, // ← added
    // Audit
    String? createdBy,
    Timestamp? createdAt,
    String? updatedBy,
    Timestamp? updatedAt,
  }) {
    return PurchaseOrderModel(
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      project: project ?? this.project,
      poName: poName ?? this.poName,
      currency: currency ?? this.currency,
      price: identical(price, _unset) ? this.price : price as int?,
      quantity: quantity ?? this.quantity,
      sellerName: sellerName ?? this.sellerName,
      sellerCompany: sellerCompany ?? this.sellerCompany,
      sellerContact: sellerContact ?? this.sellerContact,
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,
      listComponent: listComponent ?? this.listComponent,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      favorites: favorites ?? this.favorites,
      type: type ?? this.type,
      status: status ?? this.status, // ← apply
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'purchaseOrderId': purchaseOrderId,
      'project': project?.toMap(),
      'poName': poName,
      'currency': currency,
      'price': price,
      'quantity': quantity,
      'sellerName': sellerName,
      'sellerCompany': sellerCompany,
      'sellerContact': sellerContact,
      'productCategory': productCategory?.toMap(),
      'productSelection': productSelection?.toMap(),
      'listComponent': listComponent.map((e) => e.toMap()).toList(),
      'searchKeywords': searchKeywords,
      'favorites': favorites,
      'type': type.toMap(),
      'status': status, // ← added
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
    };
  }

  factory PurchaseOrderModel.fromMap(Map<String, dynamic> map) {
    List<String> asStringList(dynamic v) {
      if (v is List) return v.map((e) => e.toString()).toList();
      return const <String>[];
    }

    List<int> asIntList(dynamic v) {
      if (v is List) {
        final out = <int>[];
        for (final e in v) {
          if (e is int) {
            out.add(e);
          } else if (e is num) {
            out.add(e.toInt());
          } else if (e is String) {
            final p = int.tryParse(e);
            if (p != null) out.add(p);
          }
        }
        return out;
      }
      return const <int>[];
    }

    Map<String, dynamic> asMap(dynamic v) =>
        (v is Map) ? v.cast<String, dynamic>() : <String, dynamic>{};

    List<InventoryModel> parseComponents(dynamic v) {
      if (v is List) {
        return v
            .map((e) => InventoryModel.fromMap(asMap(e)))
            .toList(growable: false);
      }
      return const <InventoryModel>[];
    }

    ProductCategoryModel? parseCategory(dynamic v) =>
        v == null ? null : ProductCategoryModel.fromMap(asMap(v));

    ProductSelectionModel? parseSelection(dynamic v) =>
        v == null ? null : ProductSelectionModel.fromMap(asMap(v));

    ProjectModel? parseProject(dynamic v) =>
        v == null ? null : ProjectModel.fromMap(asMap(v));

    int? asIntOrNull(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return PurchaseOrderModel(
      purchaseOrderId: (map['purchaseOrderId'] ?? '') as String,
      project: parseProject(map['project']),
      poName: (map['poName'] ?? '') as String,
      currency: (map['currency'] ?? '') as String,
      price: asIntOrNull(map['price']),
      quantity: asIntList(map['quantity']),
      sellerName: (map['sellerName'] ?? '') as String,
      sellerCompany: (map['sellerCompany'] ?? '') as String,
      sellerContact: (map['sellerContact'] ?? '') as String,
      productCategory: parseCategory(map['productCategory']),
      productSelection: parseSelection(map['productSelection']),
      listComponent: parseComponents(map['listComponent']),
      searchKeywords: asStringList(map['searchKeywords']),
      favorites: asStringList(map['favorites']),
      type: TypeCategorySelectionModel.fromMap(asMap(map['type'])),
      status: (map['status'] ?? 'Active') as String, // ← added (default)
      createdBy: (map['createdBy'] ?? '') as String,
      createdAt: (map['createdAt'] as Timestamp?) ?? Timestamp(0, 0),
      updatedBy: map['updatedBy'] as String?,
      updatedAt: map['updatedAt'] as Timestamp?,
    );
  }

  String toJson() => json.encode(toMap());
  factory PurchaseOrderModel.fromJson(String source) =>
      PurchaseOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension PurchaseOrderXModel on PurchaseOrderModel {
  PurchaseOrderEntity toEntity() {
    return PurchaseOrderEntity(
      purchaseOrderId: purchaseOrderId,
      project: project?.toEntity(),
      poName: poName,
      currency: currency,
      price: price,
      quantity: quantity,
      sellerName: sellerName,
      sellerCompany: sellerCompany,
      sellerContact: sellerContact,
      productCategory: productCategory?.toEntity(),
      productSelection: productSelection?.toEntity(),
      listComponent: listComponent.map((m) => m.toEntity()).toList(),
      searchKeywords: searchKeywords,
      favorites: favorites,
      type: type.toEntity(),
      status: status,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedBy: updatedBy,
      updatedAt: updatedAt,
    );
  }
}

const Object _unset = Object();
