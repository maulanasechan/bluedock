import 'package:cloud_firestore/cloud_firestore.dart';
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

  final int dpAmount;
  final int lcAmount;

  final bool dpStatus;
  final bool lcStatus;
  final Timestamp? dpIssuedDate;
  final Timestamp? lcIssuedDate;
  final Timestamp? dpApprovedDate;
  final Timestamp? lcApprovedDate;
  final String? dpApprovedBy;
  final String? lcApprovedBy;

  final int totalPrice;
  final String currency;

  final List<String> favorites;
  final List<String> listTeamIds;
  final TypeCategorySelectionEntity type;
  final List<String> searchKeywords;

  final Timestamp createdAt;
  final String createdBy;
  final Timestamp? issuedDate;

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
    int? dpAmount,
    int? lcAmount,
    bool? dpStatus,
    bool? lcStatus,
    int? totalPrice,
    String? currency,
    List<String>? favorites,
    List<String>? listTeamIds,
    TypeCategorySelectionEntity? type,
    List<String>? searchKeywords,
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
    return InvoiceEntity(
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
}
