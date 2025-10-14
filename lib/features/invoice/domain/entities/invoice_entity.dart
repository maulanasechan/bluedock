import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';

class InvoiceEntity {
  final String invoiceId;
  final String projectId;

  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String projectStatus;

  final String customerName;
  final String customerCompany;
  final String customerContact;

  final ProductCategoryEntity productCategory;
  final ProductSelectionEntity productSelection;

  final int dpAmount;
  final int lcAmount;

  final bool dpStatus;
  final bool lcStatus;

  final int totalPrice;
  final String currency;
  final String payment;
  final int quantity;

  final List<String> favorites;
  final List<String> listTeamIds;
  final TypeCategorySelectionEntity type;
  final List<String> searchKeywords;

  final Timestamp createdAt;
  final Timestamp? dpIssuedDate;
  final Timestamp? issuedDate;
  final Timestamp? lcIssuedDate;
  final String createdBy;

  InvoiceEntity({
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

  InvoiceEntity copyWith({
    String? invoiceId,
    String? projectId,
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? projectStatus,
    String? customerName,
    String? customerCompany,
    String? customerContact,
    ProductCategoryEntity? productCategory,
    ProductSelectionEntity? productSelection,
    int? dpAmount,
    int? lcAmount,
    bool? dpStatus,
    bool? lcStatus,
    int? totalPrice,
    String? currency,
    String? payment,
    int? quantity,
    List<String>? favorites,
    List<String>? listTeamIds,
    TypeCategorySelectionEntity? type,
    List<String>? searchKeywords,
    Timestamp? dpIssuedDate,
    Timestamp? lcIssuedDate,
    Timestamp? createdAt,
    Timestamp? issuedDate,
    String? createdBy,
  }) {
    return InvoiceEntity(
      invoiceId: invoiceId ?? this.invoiceId,
      projectId: projectId ?? this.projectId,
      projectStatus: projectStatus ?? this.projectStatus,
      issuedDate: issuedDate ?? this.issuedDate,
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
    );
  }
}
