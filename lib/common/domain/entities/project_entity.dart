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

  Map<String, dynamic> toJson() => {
    'projectId': projectId,
    'invoiceId': invoiceId,
    'purchaseContractNumber': purchaseContractNumber,
    'projectName': projectName,
    'projectCode': projectCode,
    'customerName': customerName,
    'customerCompany': customerCompany,
    'payment': payment,
    'productCategory': productCategory.toJson(),
    'productSelection': productSelection.toJson(),
    'price': price,
    'currency': currency,
    'delivery': delivery,
    'quantity': quantity,
    'projectDescription': projectDescription,
    'customerContact': customerContact,
    'favorites': favorites,
    'listTeam': listTeam.map((e) => e.toJson()).toList(),
    'status': status,
    'warrantyOfGoods': warrantyOfGoods,
    'blDate': blDate,
    'commDate': commDate,
    'warrantyBlDate': warrantyBlDate,
    'warrantyCommDate': warrantyCommDate,
    'updatedAt': updatedAt,
    'createdAt': createdAt,
    'createdBy': createdBy,
  };
}
