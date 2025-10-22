import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';

class PurchaseOrderEntity {
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
  final int quantity;

  // Customer
  final String customerName;
  final String customerCompany;
  final String customerContact;

  // Selections
  final ProductCategoryEntity productCategory;
  final ProductSelectionEntity productSelection;

  /// Optional: if/when you model component selection as an entity, replace this type.
  final TypeCategorySelectionEntity? componentSelection;

  // Meta
  final List<String> listTeamIds;
  final List<String> favorites;
  final List<String> searchKeywords;
  final TypeCategorySelectionEntity type;

  // Timestamps & audit
  final Timestamp createdAt;
  final Timestamp? blDate;
  final Timestamp? arrivalDate;
  final Timestamp? updatedAt;
  final String? updatedBy;
  final String createdBy;

  PurchaseOrderEntity({
    // IDs & linkage
    required this.purchaseOrderId,
    required this.projectId,
    required this.invoiceId,

    // Project & contract
    required this.purchaseContractNumber,
    required this.projectName,
    required this.projectCode,
    required this.favorites,
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
    required this.type,

    // Timestamps & audit
    required this.createdAt,
    this.blDate,
    this.arrivalDate,
    this.updatedAt,
    this.updatedBy,
    required this.createdBy,
  });

  PurchaseOrderEntity copyWith({
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
    ProductCategoryEntity? productCategory,
    ProductSelectionEntity? productSelection,
    TypeCategorySelectionEntity? componentSelection,

    // Meta
    int? quantity,
    List<String>? listTeamIds,
    List<String>? searchKeywords,
    List<String>? favorites,
    TypeCategorySelectionEntity? type,

    // Timestamps & audit
    Timestamp? createdAt,
    Timestamp? blDate,
    Timestamp? arrivalDate,
    Timestamp? updatedAt,
    String? updatedBy,
    String? createdBy,
  }) {
    return PurchaseOrderEntity(
      // IDs & linkage
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      projectId: projectId ?? this.projectId,
      invoiceId: invoiceId ?? this.invoiceId,

      // Project & contract
      purchaseContractNumber:
          purchaseContractNumber ?? this.purchaseContractNumber,
      projectName: projectName ?? this.projectName,
      projectCode: projectCode ?? this.projectCode,
      favorites: favorites ?? this.favorites,
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
}
