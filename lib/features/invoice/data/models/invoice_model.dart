import 'dart:convert';
import 'package:bluedock/common/data/models/itemSelection/type_category_selection_model.dart';
import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bluedock/common/data/models/productCategory/product_category_model.dart';
import 'package:bluedock/common/data/models/product/product_selection_model.dart';

class InvoiceModel {
  final String invoiceId;
  final String projectId;

  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String projectStatus;

  final String customerName;
  final String customerCompany;
  final String customerContact;

  final ProductCategoryModel productCategory;
  final ProductSelectionModel productSelection;
  final List<String> listTeamIds;

  final int dpAmount;
  final int lcAmount;

  final bool dpStatus;
  final bool lcStatus;

  final int totalPrice;
  final String currency;
  final String payment;
  final int quantity;

  final List<String> favorites;
  final TypeCategorySelectionModel type;
  final List<String> searchKeywords;

  final Timestamp? dpIssuedDate;
  final Timestamp? lcIssuedDate;
  final Timestamp createdAt;
  final Timestamp? issuedDate;
  final String createdBy;

  const InvoiceModel({
    required this.invoiceId,
    required this.projectId,
    required this.purchaseContractNumber,
    required this.projectName,
    required this.projectCode,
    required this.projectStatus,
    required this.customerName,
    required this.customerCompany,
    required this.customerContact,
    required this.productCategory,
    required this.productSelection,
    required this.dpAmount,
    required this.lcAmount,
    required this.dpStatus,
    required this.lcStatus,
    required this.totalPrice,
    required this.currency,
    required this.payment,
    required this.quantity,
    required this.favorites,
    required this.type,
    required this.searchKeywords,
    required this.dpIssuedDate,
    required this.lcIssuedDate,
    required this.createdAt,
    required this.createdBy,
    required this.listTeamIds,
    required this.issuedDate,
  });

  InvoiceModel copyWith({
    String? invoiceId,
    String? projectId,
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? projectStatus,
    String? customerName,
    String? customerCompany,
    String? customerContact,
    ProductCategoryModel? productCategory,
    ProductSelectionModel? productSelection,
    int? dpAmount,
    int? lcAmount,
    bool? dpStatus,
    bool? lcStatus,
    int? totalPrice,
    String? currency,
    String? payment,
    int? quantity,
    List<String>? favorites,
    TypeCategorySelectionModel? type,
    List<String>? searchKeywords,
    List<String>? listTeamIds,
    Timestamp? dpIssuedDate,
    Timestamp? lcIssuedDate,
    Timestamp? createdAt,
    Timestamp? issuedDate,
    String? createdBy,
  }) {
    return InvoiceModel(
      invoiceId: invoiceId ?? this.invoiceId,
      projectId: projectId ?? this.projectId,
      projectStatus: projectStatus ?? this.projectStatus,
      purchaseContractNumber:
          purchaseContractNumber ?? this.purchaseContractNumber,
      projectName: projectName ?? this.projectName,
      projectCode: projectCode ?? this.projectCode,
      customerName: customerName ?? this.customerName,
      customerCompany: customerCompany ?? this.customerCompany,
      customerContact: customerContact ?? this.customerContact,
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,
      dpAmount: dpAmount ?? this.dpAmount,
      lcAmount: lcAmount ?? this.lcAmount,
      dpStatus: dpStatus ?? this.dpStatus,
      lcStatus: lcStatus ?? this.lcStatus,
      totalPrice: totalPrice ?? this.totalPrice,
      currency: currency ?? this.currency,
      payment: payment ?? this.payment,
      quantity: quantity ?? this.quantity,
      favorites: favorites ?? this.favorites,
      type: type ?? this.type,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      dpIssuedDate: dpIssuedDate ?? this.dpIssuedDate,
      lcIssuedDate: lcIssuedDate ?? this.lcIssuedDate,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      listTeamIds: listTeamIds ?? this.listTeamIds,
      issuedDate: issuedDate ?? this.issuedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'invoiceId': invoiceId,
      'projectId': projectId,
      'purchaseContractNumber': purchaseContractNumber,
      'projectName': projectName,
      'projectCode': projectCode,
      'projectStatus': projectStatus,
      'customerName': customerName,
      'customerCompany': customerCompany,
      'customerContact': customerContact,
      'productCategory': productCategory.toMap(),
      'productSelection': productSelection.toMap(),
      'dpAmount': dpAmount,
      'lcAmount': lcAmount,
      'dpStatus': dpStatus,
      'lcStatus': lcStatus,
      'totalPrice': totalPrice,
      'currency': currency,
      'payment': payment,
      'quantity': quantity,
      'favorites': favorites,
      'listTeamIds': listTeamIds,
      'type': type.toMap(),
      'searchKeywords': searchKeywords,
      'dpIssuedDate': dpIssuedDate,
      'lcIssuedDate': lcIssuedDate,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'issuedDate': issuedDate,
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    int asInt(dynamic v, {int def = 0}) {
      if (v is int) return v;
      if (v is double) return v.round();
      if (v is num) return v.toInt();
      return def;
    }

    bool asBool(dynamic v, {bool def = false}) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final s = v.toLowerCase();
        if (s == 'true' || s == '1') return true;
        if (s == 'false' || s == '0') return false;
      }
      return def;
    }

    List<String> asStringList(dynamic v) {
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      return const <String>[];
    }

    return InvoiceModel(
      invoiceId: (map['invoiceId'] ?? '') as String,
      projectId: (map['projectId'] ?? '') as String,
      purchaseContractNumber: (map['purchaseContractNumber'] ?? '') as String,
      projectName: (map['projectName'] ?? '') as String,
      projectCode: (map['projectCode'] ?? '') as String,
      projectStatus: (map['projectStatus'] ?? '') as String,
      customerName: (map['customerName'] ?? '') as String,
      customerCompany: (map['customerCompany'] ?? '') as String,
      customerContact: (map['customerContact'] ?? '') as String,

      productCategory: ProductCategoryModel.fromMap(
        (map['productCategory'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      productSelection: ProductSelectionModel.fromMap(
        (map['productSelection'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),

      dpAmount: asInt(map['dpAmount']),
      lcAmount: asInt(map['lcAmount']),

      dpStatus: asBool(map['dpStatus']),
      lcStatus: asBool(map['lcStatus']),

      totalPrice: asInt(map['totalPrice']),
      currency: (map['currency'] ?? '') as String,
      payment: (map['payment'] ?? '') as String,
      quantity: asInt(map['quantity']),

      favorites: asStringList(map['favorites']),
      listTeamIds: asStringList(map['listTeamIds']),

      type: TypeCategorySelectionModel.fromMap(
        (map['type'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),

      searchKeywords: asStringList(map['searchKeywords']),

      dpIssuedDate: map['dpIssuedDate'] as Timestamp?,
      lcIssuedDate: map['lcIssuedDate'] as Timestamp?,
      issuedDate: map['issuedDate'] as Timestamp?,
      createdAt: (map['createdAt'] as Timestamp?) ?? Timestamp(0, 0),
      createdBy: (map['createdBy'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceModel.fromJson(String source) =>
      InvoiceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension InvoiceXModel on InvoiceModel {
  InvoiceEntity toEntity() {
    return InvoiceEntity(
      invoiceId: invoiceId,
      projectId: projectId,
      projectStatus: projectStatus,
      purchaseContractNumber: purchaseContractNumber,
      projectName: projectName,
      projectCode: projectCode,
      customerName: customerName,
      customerCompany: customerCompany,
      customerContact: customerContact,
      productCategory: productCategory.toEntity(),
      productSelection: productSelection.toEntity(),
      dpAmount: dpAmount,
      lcAmount: lcAmount,
      dpStatus: dpStatus,
      lcStatus: lcStatus,
      totalPrice: totalPrice,
      currency: currency,
      payment: payment,
      quantity: quantity,
      favorites: favorites,
      type: type.toEntity(),
      searchKeywords: searchKeywords,
      listTeamIds: listTeamIds,
      lcIssuedDate: lcIssuedDate,
      dpIssuedDate: dpIssuedDate,
      createdAt: createdAt,
      createdBy: createdBy,
      issuedDate: issuedDate,
    );
  }
}
