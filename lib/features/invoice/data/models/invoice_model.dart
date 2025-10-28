import 'dart:convert';
import 'package:bluedock/common/data/models/itemSelection/type_category_selection_model.dart';
import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final List<String> listTeamIds;

  final int dpAmount;
  final int lcAmount;

  final bool dpStatus;
  final bool lcStatus;

  final int totalPrice;
  final String currency;

  final List<String> favorites;
  final TypeCategorySelectionModel type;
  final List<String> searchKeywords;

  final Timestamp? dpIssuedDate;
  final Timestamp? lcIssuedDate;
  final Timestamp? dpApprovedDate; // baru
  final Timestamp? lcApprovedDate; // baru
  final String? dpApprovedBy; // baru
  final String? lcApprovedBy; // baru

  final Timestamp createdAt;
  final String createdBy;
  final Timestamp? issuedDate; // ← dimasukkan lagi

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
    required this.dpAmount,
    required this.lcAmount,
    required this.dpStatus,
    required this.lcStatus,
    required this.totalPrice,
    required this.currency,
    required this.favorites,
    required this.type,
    required this.searchKeywords,
    required this.dpIssuedDate,
    required this.lcIssuedDate,
    required this.dpApprovedDate,
    required this.lcApprovedDate,
    required this.dpApprovedBy,
    required this.lcApprovedBy,
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
    int? dpAmount,
    int? lcAmount,
    bool? dpStatus,
    bool? lcStatus,
    int? totalPrice,
    String? currency,
    List<String>? favorites,
    TypeCategorySelectionModel? type,
    List<String>? searchKeywords,
    List<String>? listTeamIds,
    Timestamp? dpIssuedDate,
    Timestamp? lcIssuedDate,
    Timestamp? dpApprovedDate,
    Timestamp? lcApprovedDate,
    String? dpApprovedBy,
    String? lcApprovedBy,
    Timestamp? createdAt,
    String? createdBy,
    Timestamp? issuedDate,
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
      dpAmount: dpAmount ?? this.dpAmount,
      lcAmount: lcAmount ?? this.lcAmount,
      dpStatus: dpStatus ?? this.dpStatus,
      lcStatus: lcStatus ?? this.lcStatus,
      totalPrice: totalPrice ?? this.totalPrice,
      currency: currency ?? this.currency,
      favorites: favorites ?? this.favorites,
      type: type ?? this.type,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      dpIssuedDate: dpIssuedDate ?? this.dpIssuedDate,
      lcIssuedDate: lcIssuedDate ?? this.lcIssuedDate,
      dpApprovedDate: dpApprovedDate ?? this.dpApprovedDate,
      lcApprovedDate: lcApprovedDate ?? this.lcApprovedDate,
      dpApprovedBy: dpApprovedBy ?? this.dpApprovedBy,
      lcApprovedBy: lcApprovedBy ?? this.lcApprovedBy,
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
      'dpAmount': dpAmount,
      'lcAmount': lcAmount,
      'dpStatus': dpStatus,
      'lcStatus': lcStatus,
      'totalPrice': totalPrice,
      'currency': currency,
      'favorites': favorites,
      'listTeamIds': listTeamIds,
      'type': type.toMap(),
      'searchKeywords': searchKeywords,
      'dpIssuedDate': dpIssuedDate,
      'lcIssuedDate': lcIssuedDate,
      'dpApprovedDate': dpApprovedDate,
      'lcApprovedDate': lcApprovedDate,
      'dpApprovedBy': dpApprovedBy,
      'lcApprovedBy': lcApprovedBy,
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

    Map<String, dynamic> asMap(dynamic v) {
      if (v is Map) {
        return v.cast<String, dynamic>();
      }
      return const <String, dynamic>{};
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
      dpAmount: asInt(map['dpAmount']),
      lcAmount: asInt(map['lcAmount']),
      dpStatus: asBool(map['dpStatus']),
      lcStatus: asBool(map['lcStatus']),
      totalPrice: asInt(map['totalPrice']),
      currency: (map['currency'] ?? '') as String,
      favorites: asStringList(map['favorites']),
      listTeamIds: asStringList(map['listTeamIds']),
      type: TypeCategorySelectionModel.fromMap(asMap(map['type'])),
      searchKeywords: asStringList(map['searchKeywords']),
      dpIssuedDate: map['dpIssuedDate'] as Timestamp?,
      lcIssuedDate: map['lcIssuedDate'] as Timestamp?,
      dpApprovedDate: map['dpApprovedDate'] as Timestamp?,
      lcApprovedDate: map['lcApprovedDate'] as Timestamp?,
      dpApprovedBy: (map['dpApprovedBy'] as String?)?.toString(),
      lcApprovedBy: (map['lcApprovedBy'] as String?)?.toString(),
      createdAt: (map['createdAt'] as Timestamp?) ?? Timestamp(0, 0),
      createdBy: (map['createdBy'] ?? '') as String,
      issuedDate: map['issuedDate'] as Timestamp?,
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
      dpAmount: dpAmount,
      lcAmount: lcAmount,
      dpStatus: dpStatus,
      lcStatus: lcStatus,
      totalPrice: totalPrice,
      currency: currency,
      favorites: favorites,
      type: type.toEntity(),
      searchKeywords: searchKeywords,
      listTeamIds: listTeamIds,
      lcIssuedDate: lcIssuedDate,
      dpIssuedDate: dpIssuedDate,
      dpApprovedDate: dpApprovedDate,
      lcApprovedDate: lcApprovedDate,
      dpApprovedBy: dpApprovedBy,
      lcApprovedBy: lcApprovedBy,
      createdAt: createdAt,
      createdBy: createdBy,
      issuedDate: issuedDate,
    );
  }
}
