import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseOrderEntity {
  // IDs & linkage
  final String purchaseOrderId;
  final ProjectEntity? project;
  final String poName;

  // Project & contract
  final String currency;
  final int? price;
  final List<int> quantity;

  // Seller
  final String sellerName;
  final String sellerCompany;
  final String sellerContact;

  // Selections
  final ProductCategoryEntity? productCategory;
  final ProductSelectionEntity? productSelection;

  // Meta
  final List<InventoryEntity> listComponent;
  final List<String> searchKeywords;
  final List<String> favorites;
  final TypeCategorySelectionEntity type;
  final String status; // ← added

  // Audit
  final String createdBy;
  final Timestamp createdAt;
  final String? updatedBy;
  final Timestamp? updatedAt;

  PurchaseOrderEntity({
    required this.purchaseOrderId,
    this.project,
    this.poName = '',
    required this.currency,
    this.price,
    required this.quantity,
    this.sellerName = '',
    this.sellerCompany = '',
    this.sellerContact = '',
    this.productCategory,
    this.productSelection,
    this.listComponent = const <InventoryEntity>[],
    required this.searchKeywords,
    this.favorites = const <String>[],
    required this.type,
    this.status = 'Active', // ← added (default)
    required this.createdBy,
    required this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  PurchaseOrderEntity copyWith({
    String? purchaseOrderId,
    ProjectEntity? project,
    String? poName,
    String? currency,
    Object? price = _unset,
    List<int>? quantity,
    String? sellerName,
    String? sellerCompany,
    String? sellerContact,
    ProductCategoryEntity? productCategory,
    ProductSelectionEntity? productSelection,
    List<InventoryEntity>? listComponent,
    List<String>? searchKeywords,
    List<String>? favorites,
    TypeCategorySelectionEntity? type,
    String? status, // ← added
    String? createdBy,
    Timestamp? createdAt,
    String? updatedBy,
    Timestamp? updatedAt,
  }) {
    return PurchaseOrderEntity(
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      project: project ?? this.project,
      poName: poName ?? this.poName,
      currency: currency ?? this.currency,
      price: identical(price, _unset) ? this.price : price as int?,
      quantity: quantity ?? this.quantity,
      sellerName: sellerName ?? this.sellerName,
      sellerCompany: sellerCompany ?? this.sellerCompany,
      sellerContact: sellerContact ?? this.sellerContact,
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,
      listComponent: listComponent ?? this.listComponent,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      favorites: favorites ?? this.favorites,
      type: type ?? this.type,
      status: status ?? this.status, // ← apply
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static const Object _unset = Object();

  Map<String, dynamic> toJson() => <String, dynamic>{
    // IDs & linkage
    'purchaseOrderId': purchaseOrderId,
    'project': project?.toJson(),
    'poName': poName,

    // Project & contract
    'currency': currency,
    'price': price,
    'quantity': quantity,

    // Seller
    'sellerName': sellerName,
    'sellerCompany': sellerCompany,
    'sellerContact': sellerContact,

    // Selections
    'productCategory': productCategory?.toJson(),
    'productSelection': productSelection?.toJson(),

    // Meta
    'listComponent': listComponent.map((e) => e.toJson()).toList(),
    'searchKeywords': searchKeywords,
    'favorites': favorites,
    'type': type.toJson(),
    'status': status,

    // Audit
    'createdBy': createdBy,
    'createdAt': createdAt,
    'updatedBy': updatedBy,
    'updatedAt': updatedAt,
  };
}
