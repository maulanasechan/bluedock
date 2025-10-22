import 'dart:convert';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bluedock/common/data/models/productCategory/product_category_model.dart';
import 'package:bluedock/common/data/models/product/product_selection_model.dart';
import 'package:bluedock/common/data/models/itemSelection/type_category_selection_model.dart';

class PurchaseOrderModel {
  // IDs & linkage
  final String purchaseOrderId;
  final String projectId;
  final String invoiceId;

  // Project & contract
  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String projectStatus;
  final String currency;
  final int? price;

  // Customer
  final String customerName;
  final String customerCompany;
  final String customerContact;

  // Selections
  final ProductCategoryModel productCategory;
  final ProductSelectionModel productSelection;

  /// Opsional (placeholder). Jika nanti ada `ComponentSelectionModel` sendiri,
  /// ganti tipe ini dan mappingnya.
  final TypeCategorySelectionModel? componentSelection;

  // Meta
  final int quantity;
  final List<String> listTeamIds;
  final List<String> searchKeywords;
  final List<String> favorites;
  final TypeCategorySelectionModel type;

  // Timestamps & audit
  final Timestamp createdAt;
  final Timestamp? blDate;
  final Timestamp? arrivalDate;
  final Timestamp? updatedAt;
  final String? updatedBy;
  final String createdBy;

  const PurchaseOrderModel({
    // IDs & linkage
    required this.purchaseOrderId,
    required this.projectId,
    required this.invoiceId,

    // Project & contract
    required this.purchaseContractNumber,
    required this.projectName,
    required this.projectCode,
    required this.projectStatus,
    required this.currency,
    this.price,

    // Customer
    required this.customerName,
    required this.customerCompany,
    required this.customerContact,

    // Selections
    required this.productCategory,
    required this.productSelection,
    this.componentSelection,

    // Meta
    required this.quantity,
    required this.listTeamIds,
    required this.searchKeywords,
    required this.favorites,
    required this.type,

    // Timestamps & audit
    required this.createdAt,
    this.blDate,
    this.arrivalDate,
    this.updatedAt,
    this.updatedBy,
    required this.createdBy,
  });

  PurchaseOrderModel copyWith({
    // IDs & linkage
    String? purchaseOrderId,
    String? projectId,
    String? invoiceId,

    // Project & contract
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? projectStatus,
    String? currency,
    int? price,

    // Customer
    String? customerName,
    String? customerCompany,
    String? customerContact,

    // Selections
    ProductCategoryModel? productCategory,
    ProductSelectionModel? productSelection,
    TypeCategorySelectionModel? componentSelection,

    // Meta
    int? quantity,
    List<String>? listTeamIds,
    List<String>? searchKeywords,
    List<String>? favorites,
    TypeCategorySelectionModel? type,

    // Timestamps & audit
    Timestamp? createdAt,
    Timestamp? blDate,
    Timestamp? arrivalDate,
    Timestamp? updatedAt,
    String? updatedBy,
    String? createdBy,
  }) {
    return PurchaseOrderModel(
      // IDs & linkage
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      projectId: projectId ?? this.projectId,
      invoiceId: invoiceId ?? this.invoiceId,
      favorites: favorites ?? this.favorites,

      // Project & contract
      purchaseContractNumber:
          purchaseContractNumber ?? this.purchaseContractNumber,
      projectName: projectName ?? this.projectName,
      projectCode: projectCode ?? this.projectCode,
      projectStatus: projectStatus ?? this.projectStatus,
      currency: currency ?? this.currency,
      price: price ?? this.price,

      // Customer
      customerName: customerName ?? this.customerName,
      customerCompany: customerCompany ?? this.customerCompany,
      customerContact: customerContact ?? this.customerContact,

      // Selections
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,
      componentSelection: componentSelection ?? this.componentSelection,

      // Meta
      quantity: quantity ?? this.quantity,
      listTeamIds: listTeamIds ?? this.listTeamIds,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      type: type ?? this.type,

      // Timestamps & audit
      createdAt: createdAt ?? this.createdAt,
      blDate: blDate ?? this.blDate,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'purchaseOrderId': purchaseOrderId,
      'projectId': projectId,
      'invoiceId': invoiceId,
      'purchaseContractNumber': purchaseContractNumber,
      'projectName': projectName,
      'projectCode': projectCode,
      'projectStatus': projectStatus,
      'customerName': customerName,
      'customerCompany': customerCompany,
      'customerContact': customerContact,
      'productCategory': productCategory.toMap(),
      'productSelection': productSelection.toMap(),
      'componentSelection': componentSelection?.toMap(), // bisa null
      'quantity': quantity,
      'listTeamIds': listTeamIds,
      'searchKeywords': searchKeywords,
      'type': type.toMap(),
      'createdAt': createdAt,
      'blDate': blDate,
      'arrivalDate': arrivalDate,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'createdBy': createdBy,
      'favorites': favorites,
      'currency': currency,
      'price': price,
    };
  }

  factory PurchaseOrderModel.fromMap(Map<String, dynamic> map) {
    int asInt(dynamic v, {int def = 0}) {
      if (v is int) return v;
      if (v is double) return v.round();
      if (v is num) return v.toInt();
      return def;
    }

    List<String> asStringList(dynamic v) {
      if (v is List) return v.map((e) => e.toString()).toList();
      return const <String>[];
    }

    Map<String, dynamic> asMap(dynamic v) {
      return (v is Map) ? v.cast<String, dynamic>() : <String, dynamic>{};
    }

    int? asIntOrNull(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.round();
      if (v is num) return v.toInt();
      if (v is String) {
        final p = int.tryParse(v);
        if (p != null) return p;
      }
      return null;
    }

    return PurchaseOrderModel(
      // IDs & linkage
      purchaseOrderId: (map['purchaseOrderId'] ?? '') as String,
      projectId: (map['projectId'] ?? '') as String,
      invoiceId: (map['invoiceId'] ?? '') as String,

      // Project & contract
      purchaseContractNumber: (map['purchaseContractNumber'] ?? '') as String,
      projectName: (map['projectName'] ?? '') as String,
      projectCode: (map['projectCode'] ?? '') as String,
      projectStatus: (map['projectStatus'] ?? '') as String,
      currency: (map['currency'] ?? '') as String,
      price: asIntOrNull(map['price']),

      // Customer
      customerName: (map['customerName'] ?? '') as String,
      customerCompany: (map['customerCompany'] ?? '') as String,
      customerContact: (map['customerContact'] ?? '') as String,

      // Selections
      productCategory: ProductCategoryModel.fromMap(
        asMap(map['productCategory']),
      ),
      productSelection: ProductSelectionModel.fromMap(
        asMap(map['productSelection']),
      ),
      componentSelection: (map['componentSelection'] == null)
          ? null
          : TypeCategorySelectionModel.fromMap(
              asMap(map['componentSelection']),
            ),

      // Meta
      quantity: asInt(map['quantity']),
      listTeamIds: asStringList(map['listTeamIds']),
      searchKeywords: asStringList(map['searchKeywords']),
      favorites: asStringList(map['favorites']),
      type: TypeCategorySelectionModel.fromMap(asMap(map['type'])),

      // Timestamps & audit
      createdAt: (map['createdAt'] as Timestamp?) ?? Timestamp(0, 0),
      blDate: map['blDate'] as Timestamp?,
      arrivalDate: map['arrivalDate'] as Timestamp?,
      updatedAt: map['updatedAt'] as Timestamp?,
      updatedBy: (map['updatedBy'] as String?),
      createdBy: (map['createdBy'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseOrderModel.fromJson(String source) =>
      PurchaseOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension PurchaseOrderXModel on PurchaseOrderModel {
  PurchaseOrderEntity toEntity() {
    return PurchaseOrderEntity(
      // IDs & linkage
      purchaseOrderId: purchaseOrderId,
      projectId: projectId,
      invoiceId: invoiceId,
      favorites: favorites,

      // Project & contract
      purchaseContractNumber: purchaseContractNumber,
      projectName: projectName,
      projectCode: projectCode,
      projectStatus: projectStatus,
      currency: currency,
      price: price,

      // Customer
      customerName: customerName,
      customerCompany: customerCompany,
      customerContact: customerContact,

      // Selections
      productCategory: productCategory.toEntity(),
      productSelection: productSelection.toEntity(),
      componentSelection: componentSelection?.toEntity(),

      // Meta
      quantity: quantity,
      listTeamIds: listTeamIds,
      searchKeywords: searchKeywords,
      type: type.toEntity(),

      // Timestamps & audit
      createdAt: createdAt,
      blDate: blDate,
      arrivalDate: arrivalDate,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      createdBy: createdBy,
    );
  }
}
