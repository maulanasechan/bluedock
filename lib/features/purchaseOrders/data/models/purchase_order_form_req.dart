import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';

class PurchaseOrderFormReq {
  // IDs & linkage
  final ProjectEntity? project;
  final String purchaseOrderId;
  final String poName; // ← ditambahkan

  // Project & contract
  final String currency;
  final int? price; // nullable
  final List<int> quantity; // disesuaikan: const [0]

  // Seller
  final String sellerName;
  final String sellerCompany;
  final String sellerContact;

  // Selections
  final ProductCategoryEntity? productCategory;
  final ProductSelectionEntity? productSelection;

  // Meta
  final List<InventoryEntity> listComponent;
  final int componentLength;

  final TypeCategorySelectionEntity type; // tipe dokumen (PO)
  final List<String> searchKeywords;

  const PurchaseOrderFormReq({
    // IDs & linkage
    this.project,
    this.purchaseOrderId = '',
    this.poName = '',

    // Project & contract
    this.currency = 'USD',
    this.price,
    this.quantity = const [],

    // Seller
    this.sellerName = '',
    this.sellerCompany = '',
    this.sellerContact = '',

    // Selections
    this.productCategory,
    this.productSelection,
    this.listComponent = const <InventoryEntity>[],
    this.componentLength = 1,

    this.type = const TypeCategorySelectionEntity(
      selectionId: 'SnSu62diYMdF0FzOItzJ',
      title: 'Project',
      image: 'assets/icons/project.png',
      color: '0F6CBB',
    ),
    this.searchKeywords = const <String>[],
  });

  PurchaseOrderFormReq copyWith({
    // IDs & linkage
    ProjectEntity? project,
    String? purchaseOrderId,
    String? poName,

    // Project & contract
    String? currency,
    Object? price = _unset,
    List<int>? quantity,

    // Seller
    String? sellerName,
    String? sellerCompany,
    String? sellerContact,

    // Selections
    ProductCategoryEntity? productCategory,
    ProductSelectionEntity? productSelection,

    // Meta
    List<InventoryEntity>? listComponent,
    int? componentLength,

    TypeCategorySelectionEntity? type,
    List<String>? searchKeywords,
  }) {
    return PurchaseOrderFormReq(
      // IDs & linkage
      project: project ?? this.project,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      poName: poName ?? this.poName,

      // Project & contract
      currency: currency ?? this.currency,
      price: identical(price, _unset) ? this.price : price as int?,
      quantity: quantity ?? this.quantity,

      // Seller
      sellerName: sellerName ?? this.sellerName,
      sellerCompany: sellerCompany ?? this.sellerCompany,
      sellerContact: sellerContact ?? this.sellerContact,

      // Selections
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,

      // Meta
      listComponent: listComponent ?? this.listComponent,
      componentLength: componentLength ?? this.componentLength,

      type: type ?? this.type,
      searchKeywords: searchKeywords ?? this.searchKeywords,
    );
  }

  static const Object _unset = Object();
}
