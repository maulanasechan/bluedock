import 'dart:convert';
import 'package:bluedock/common/data/models/productCategory/product_category_model.dart';
import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/common/data/models/product/product_selection_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String projectId;
  final String invoiceId;
  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String customerName;
  final String payment;

  final ProductCategoryModel productCategory;
  final ProductSelectionModel productSelection;

  final int price;
  final String currency;
  final String delivery;
  final String warrantyOfGoods;
  final int quantity;
  final String projectDescription;
  final String customerContact;
  final String customerCompany;
  final List<String> favorites;
  final List<StaffEntity> listTeam;

  final String status;
  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;

  final Timestamp? blDate;
  final Timestamp? commDate;
  final Timestamp? warrantyBlDate;
  final Timestamp? warrantyCommDate;

  const ProjectModel({
    required this.projectId,
    required this.invoiceId,
    required this.purchaseContractNumber,
    required this.projectName,
    required this.projectCode,
    required this.customerName,
    required this.productCategory,
    required this.productSelection,
    required this.price,
    required this.currency,
    required this.delivery,
    required this.warrantyOfGoods,
    required this.quantity,
    required this.projectDescription,
    required this.favorites,
    required this.customerContact,
    required this.listTeam,
    required this.payment,
    required this.status,
    required this.customerCompany,
    required this.updatedAt,
    required this.createdAt,
    required this.createdBy,
    required this.blDate,
    required this.commDate,
    required this.warrantyBlDate,
    required this.warrantyCommDate,
  });

  ProjectModel copyWith({
    String? projectId,
    String? invoiceId,
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? customerName,
    String? payment,
    String? status,
    ProductCategoryModel? productCategory,
    ProductSelectionModel? productSelection,
    int? price,
    String? currency,
    String? delivery,
    String? warrantyOfGoods,
    int? quantity,
    String? projectDescription,
    String? customerContact,
    String? customerCompany,
    List<String>? favorites,
    List<StaffEntity>? listTeam,

    Timestamp? blDate,
    Timestamp? commDate,
    Timestamp? warrantyBlDate,
    Timestamp? warrantyCommDate,

    Timestamp? updatedAt,
    Timestamp? createdAt,
    String? createdBy,
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      invoiceId: invoiceId ?? this.invoiceId,
      payment: payment ?? this.payment,
      status: status ?? this.status,
      purchaseContractNumber:
          purchaseContractNumber ?? this.purchaseContractNumber,
      projectName: projectName ?? this.projectName,
      projectCode: projectCode ?? this.projectCode,
      customerName: customerName ?? this.customerName,
      customerCompany: customerCompany ?? this.customerCompany,
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      delivery: delivery ?? this.delivery,
      warrantyOfGoods: warrantyOfGoods ?? this.warrantyOfGoods,
      quantity: quantity ?? this.quantity,
      projectDescription: projectDescription ?? this.projectDescription,
      customerContact: customerContact ?? this.customerContact,
      listTeam: listTeam ?? this.listTeam,
      favorites: favorites ?? this.favorites,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      blDate: blDate ?? this.blDate,
      commDate: commDate ?? this.commDate,
      warrantyBlDate: warrantyBlDate ?? this.warrantyBlDate,
      warrantyCommDate: warrantyCommDate ?? this.warrantyCommDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'projectId': projectId,
      'invoiceId': invoiceId,
      'payment': payment,
      'purchaseContractNumber': purchaseContractNumber,
      'projectName': projectName,
      'projectCode': projectCode,
      'customerName': customerName,
      'status': status,
      'customerCompany': customerCompany,
      'productCategory': productCategory.toMap(),
      'productSelection': productSelection.toMap(),
      'price': price,
      'currency': currency,
      'delivery': delivery,
      'warrantyOfGoods': warrantyOfGoods,
      'quantity': quantity,
      'projectDescription': projectDescription,
      'customerContact': customerContact,
      'favorites': favorites,
      'listTeam': listTeam.map((e) => e.toJson()).toList(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'blDate': blDate,
      'commDate': commDate,
      'warrantyBlDate': warrantyBlDate,
      'warrantyCommDate': warrantyCommDate,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    int asInt(dynamic v, {int def = 0}) {
      if (v is int) return v;
      if (v is double) return v.round();
      if (v is num) return v.toInt();
      return def;
    }

    return ProjectModel(
      projectId: (map['projectId'] ?? '') as String,
      status: (map['status'] ?? '') as String,
      invoiceId: (map['invoiceId'] ?? '') as String,
      payment: (map['payment'] ?? '') as String,
      customerCompany: (map['customerCompany'] ?? '') as String,
      purchaseContractNumber: (map['purchaseContractNumber'] ?? '') as String,
      projectName: (map['projectName'] ?? '') as String,
      projectCode: (map['projectCode'] ?? '') as String,
      customerName: (map['customerName'] ?? '') as String,
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
      delivery: (map['delivery'] ?? '') as String,
      warrantyOfGoods: (map['warrantyOfGoods'] ?? '') as String,
      quantity: asInt(map['quantity']),
      projectDescription: (map['projectDescription'] ?? '') as String,
      customerContact: (map['customerContact'] ?? '') as String,
      favorites: (map['favorites'] is List)
          ? List<String>.from(
              (map['favorites'] as List).map((e) => e.toString()),
            )
          : const <String>[],
      listTeam: (map['listTeam'] is List)
          ? (map['listTeam'] as List)
                .map(
                  (e) =>
                      StaffEntity.fromJson(Map<String, dynamic>.from(e as Map)),
                )
                .toList()
          : const <StaffEntity>[],
      updatedAt: map['updatedAt'],
      createdAt: map['createdAt'] ?? Timestamp(0, 0),
      createdBy: map['createdBy'] ?? '',
      blDate: map['blDate'],
      commDate: map['commDate'],
      warrantyBlDate: map['warrantyBlDate'],
      warrantyCommDate: map['warrantyCommDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension ProjectXModel on ProjectModel {
  ProjectEntity toEntity() {
    return ProjectEntity(
      projectId: projectId,
      status: status,
      invoiceId: invoiceId,
      payment: payment,
      purchaseContractNumber: purchaseContractNumber,
      projectName: projectName,
      projectCode: projectCode,
      customerName: customerName,
      customerCompany: customerCompany,
      productCategory: productCategory.toEntity(),
      productSelection: productSelection.toEntity(),
      price: price,
      currency: currency,
      delivery: delivery,
      warrantyOfGoods: warrantyOfGoods,
      quantity: quantity,
      projectDescription: projectDescription,
      customerContact: customerContact,
      favorites: favorites,
      listTeam: listTeam,
      updatedAt: updatedAt,
      createdAt: createdAt,
      createdBy: createdBy,
      blDate: blDate,
      commDate: commDate,
      warrantyBlDate: warrantyBlDate,
      warrantyCommDate: warrantyCommDate,
    );
  }
}
