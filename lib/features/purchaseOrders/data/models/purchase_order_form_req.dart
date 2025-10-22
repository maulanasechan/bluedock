import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';

class PurchaseOrderFormReq {
  // IDs & linkage
  final String projectId;
  final String invoiceId;
  final String purchaseOrderId;

  // Project & contract
  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String projectStatus; // e.g. Inactive/Active/Done
  final String currency;
  final int? price; // nullable sesuai permintaan
  final int quantity;

  // Customer
  final String customerName;
  final String customerCompany;
  final String customerContact;

  // Selections
  final ProductCategoryEntity? productCategory;
  final ProductSelectionEntity? productSelection;
  final TypeCategorySelectionEntity? componentSelection;

  // Meta
  final List<StaffEntity> listTeam; // biar UI toggle pakai StaffEntity
  final TypeCategorySelectionEntity? type; // tipe dokumen (PO)
  final List<String> searchKeywords;

  // Audit/time (opsional di form, tapi keep supaya mudah hydrate)
  final DateTime? blDate;
  final DateTime? arrivalDate;

  const PurchaseOrderFormReq({
    // IDs & linkage
    this.projectId = '',
    this.invoiceId = '',
    this.purchaseOrderId = '',

    // Project & contract
    this.purchaseContractNumber = '',
    this.projectName = '',
    this.projectCode = '',
    this.projectStatus = '',
    this.currency = 'USD',
    this.price,
    this.quantity = 0,

    // Customer
    this.customerName = '',
    this.customerCompany = '',
    this.customerContact = '',

    // Selections
    this.productCategory,
    this.productSelection,
    this.componentSelection,

    // Meta
    this.listTeam = const <StaffEntity>[],
    this.type,
    this.searchKeywords = const <String>[],

    // Audit
    this.blDate,
    this.arrivalDate,
  });

  PurchaseOrderFormReq copyWith({
    // IDs & linkage
    String? projectId,
    String? invoiceId,
    String? purchaseOrderId,

    // Project & contract
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? projectStatus,
    String? currency,
    Object? price = _unset, // sentinel untuk bisa null-in
    int? quantity,

    // Customer
    String? customerName,
    String? customerCompany,
    String? customerContact,

    // Selections
    ProductCategoryEntity? productCategory,
    ProductSelectionEntity? productSelection,
    TypeCategorySelectionEntity? componentSelection,

    // Meta
    List<StaffEntity>? listTeam,
    TypeCategorySelectionEntity? type,
    List<String>? searchKeywords,

    // Audit
    DateTime? blDate,
    DateTime? arrivalDate,
  }) {
    return PurchaseOrderFormReq(
      projectId: projectId ?? this.projectId,
      invoiceId: invoiceId ?? this.invoiceId,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      purchaseContractNumber:
          purchaseContractNumber ?? this.purchaseContractNumber,
      projectName: projectName ?? this.projectName,
      projectCode: projectCode ?? this.projectCode,
      projectStatus: projectStatus ?? this.projectStatus,
      currency: currency ?? this.currency,
      price: identical(price, _unset) ? this.price : price as int?,
      quantity: quantity ?? this.quantity,
      customerName: customerName ?? this.customerName,
      customerCompany: customerCompany ?? this.customerCompany,
      customerContact: customerContact ?? this.customerContact,
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,
      componentSelection: componentSelection ?? this.componentSelection,
      listTeam: listTeam ?? this.listTeam,
      type: type ?? this.type,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      blDate: blDate ?? this.blDate,
      arrivalDate: arrivalDate ?? this.arrivalDate,
    );
  }

  static const Object _unset = Object();
}
