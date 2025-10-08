import 'dart:convert';
import 'package:bluedock/features/project/domain/entities/project_entity.dart';
import 'package:bluedock/features/project/data/models/selection/category_selection_model.dart';
import 'package:bluedock/features/project/data/models/selection/product_selection_model.dart';
import 'package:bluedock/features/project/domain/entities/selection/staff_selection_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String projectId;
  final String invoiceId;
  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String customerName;
  final String payment;

  final CategorySelectionModel productCategory;
  final ProductSelectionModel productSelection;

  final int price;
  final String currency;
  final String delivery;
  final String warrantyOfGoods;
  final int quantity;
  final String projectDescription;
  final int maintenancePeriod;
  final String maintenanceCurrency;
  final String customerContact;
  final String customerCompany;
  final List<String> favorites;
  final List<StaffSelectionEntity> listTeam;

  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;

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
    required this.maintenancePeriod,
    required this.maintenanceCurrency,
    required this.favorites,
    required this.customerContact,
    required this.listTeam,
    required this.payment,
    required this.customerCompany,
    required this.updatedBy,
    required this.updatedAt,
    required this.createdAt,
    required this.createdBy,
  });

  ProjectModel copyWith({
    String? projectId,
    String? invoiceId,
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? customerName,
    String? payment,
    CategorySelectionModel? productCategory,
    ProductSelectionModel? productSelection,
    int? price,
    String? currency,
    String? delivery,
    String? warrantyOfGoods,
    int? quantity,
    String? projectDescription,
    int? maintenancePeriod,
    String? maintenanceCurrency,
    String? customerContact,
    String? customerCompany,
    List<String>? favorites,
    List<StaffSelectionEntity>? listTeam,

    String? updatedBy,
    Timestamp? updatedAt,
    Timestamp? createdAt,
    String? createdBy,
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      invoiceId: invoiceId ?? this.invoiceId,
      payment: payment ?? this.payment,
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
      maintenancePeriod: maintenancePeriod ?? this.maintenancePeriod,
      maintenanceCurrency: maintenanceCurrency ?? this.maintenanceCurrency,
      customerContact: customerContact ?? this.customerContact,
      listTeam: listTeam ?? this.listTeam,
      favorites: favorites ?? this.favorites,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
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
      'customerCompany': customerCompany,
      'productCategory': productCategory.toMap(),
      'productSelection': productSelection.toMap(),
      'price': price,
      'currency': currency,
      'delivery': delivery,
      'warrantyOfGoods': warrantyOfGoods,
      'quantity': quantity,
      'projectDescription': projectDescription,
      'maintenancePeriod': maintenancePeriod,
      'maintenanceCurrency': maintenanceCurrency,
      'customerContact': customerContact,
      'favorites': favorites,
      'listTeam': listTeam.map((e) => e.toJson()).toList(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'createdBy': createdBy,
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
      invoiceId: (map['invoiceId'] ?? '') as String,
      payment: (map['payment'] ?? '') as String,
      customerCompany: (map['customerCompany'] ?? '') as String,
      purchaseContractNumber: (map['purchaseContractNumber'] ?? '') as String,
      projectName: (map['projectName'] ?? '') as String,
      projectCode: (map['projectCode'] ?? '') as String,
      customerName: (map['customerName'] ?? '') as String,
      productCategory: CategorySelectionModel.fromMap(
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
      maintenancePeriod: asInt(map['maintenancePeriod']),
      maintenanceCurrency: (map['maintenanceCurrency'] ?? '') as String,
      customerContact: (map['customerContact'] ?? '') as String,
      favorites: (map['favorites'] is List)
          ? List<String>.from(
              (map['favorites'] as List).map((e) => e.toString()),
            )
          : const <String>[],
      listTeam: (map['listTeam'] is List)
          ? (map['listTeam'] as List)
                .map(
                  (e) => StaffSelectionEntity.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const <StaffSelectionEntity>[],
      updatedBy: map['updatedBy'] ?? '',
      updatedAt: map['updatedAt'],
      createdAt: map['createdAt'] ?? Timestamp(0, 0),
      createdBy: map['createdBy'] ?? '',
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
      maintenancePeriod: maintenancePeriod,
      maintenanceCurrency: maintenanceCurrency,
      customerContact: customerContact,
      favorites: favorites,
      listTeam: listTeam,
      updatedBy: updatedBy,
      updatedAt: updatedAt,
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }
}
