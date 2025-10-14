import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectEntity {
  final String projectId;
  final String invoiceId;
  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String customerName;
  final String customerCompany;
  final String payment;
  final ProductCategoryEntity productCategory;
  final ProductSelectionEntity productSelection;
  final int price;
  final String currency;
  final String delivery;
  final int quantity;
  final String projectDescription;
  final int maintenancePeriod;
  final String maintenanceCurrency;
  final String customerContact;
  final List<String> favorites;
  final List<StaffEntity> listTeam;
  final String status;

  final String warrantyOfGoods;
  final Timestamp? blDate;
  final Timestamp? commDate;
  final Timestamp? warrantyBlDate;
  final Timestamp? warrantyCommDate;

  final Timestamp? updatedAt;
  final Timestamp createdAt;
  final String createdBy;

  ProjectEntity({
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
    required this.customerContact,
    required this.status,
    required this.favorites,
    required this.listTeam,
    required this.payment,
    required this.customerCompany,
    required this.updatedAt,
    required this.createdAt,
    required this.createdBy,
    required this.blDate,
    required this.commDate,
    required this.warrantyBlDate,
    required this.warrantyCommDate,
  });

  ProjectEntity copyWith({
    String? projectId,
    String? invoiceId,
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? customerName,
    String? customerCompany,
    String? payment,
    List<String>? favorites,
    ProductCategoryEntity? productCategory,
    ProductSelectionEntity? productSelection,
    int? price,
    String? currency,
    String? delivery,
    String? warrantyOfGoods,
    int? quantity,
    String? projectDescription,
    String? status,
    int? maintenancePeriod,
    String? maintenanceCurrency,
    String? customerContact,
    List<StaffEntity>? listTeam,

    Timestamp? blDate,
    Timestamp? commDate,
    Timestamp? warrantyBlDate,
    Timestamp? warrantyCommDate,

    Timestamp? updatedAt,
    Timestamp? createdAt,
    String? createdBy,
  }) {
    return ProjectEntity(
      projectId: projectId ?? this.projectId,
      invoiceId: invoiceId ?? this.invoiceId,
      favorites: favorites ?? this.favorites,
      customerCompany: customerCompany ?? this.customerCompany,
      payment: payment ?? this.payment,
      status: status ?? this.status,
      purchaseContractNumber:
          purchaseContractNumber ?? this.purchaseContractNumber,
      projectName: projectName ?? this.projectName,
      projectCode: projectCode ?? this.projectCode,
      customerName: customerName ?? this.customerName,
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
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      blDate: blDate ?? this.blDate,
      commDate: commDate ?? this.commDate,
      warrantyBlDate: warrantyBlDate ?? this.warrantyBlDate,
      warrantyCommDate: warrantyCommDate ?? this.warrantyCommDate,
    );
  }
}
