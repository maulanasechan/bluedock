import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';

class PurchaseOrderFormCubit extends Cubit<PurchaseOrderFormReq> {
  PurchaseOrderFormCubit() : super(const PurchaseOrderFormReq());

  // ===== IDs & linkage =====
  void setProjectId(String v) => emit(state.copyWith(projectId: v));
  void setInvoiceId(String v) => emit(state.copyWith(invoiceId: v));
  void setPurchaseOrderId(String v) => emit(state.copyWith(purchaseOrderId: v));

  // ===== Project & contract =====
  void setPurchaseContractNumber(String v) =>
      emit(state.copyWith(purchaseContractNumber: v));
  void setProjectName(String v) => emit(state.copyWith(projectName: v));
  void setProjectCode(String v) => emit(state.copyWith(projectCode: v));
  void setProjectStatus(String v) => emit(state.copyWith(projectStatus: v));
  void setCurrency(String v) => emit(state.copyWith(currency: v));

  /// price nullable: gunakan setter dari text dan dari int?
  void setPriceInt(int? v) => emit(state.copyWith(price: v));
  void setPriceFromText(String v) {
    final parsed = int.tryParse(v.trim());
    emit(state.copyWith(price: parsed)); // bisa null kalau parse gagal
  }

  void setQuantity(int v) => emit(state.copyWith(quantity: v));
  void setQuantityFromText(String v) {
    final parsed = int.tryParse(v.trim()) ?? 0;
    emit(state.copyWith(quantity: parsed));
  }

  // ===== Customer =====
  void setCustomerName(String v) => emit(state.copyWith(customerName: v));
  void setCustomerCompany(String v) => emit(state.copyWith(customerCompany: v));
  void setCustomerContact(String v) => emit(state.copyWith(customerContact: v));

  // ===== Selections =====
  void setProductCategory(ProductCategoryEntity v) =>
      emit(state.copyWith(productCategory: v));
  void setProductSelection(ProductSelectionEntity v) =>
      emit(state.copyWith(productSelection: v));
  void setComponentSelection(TypeCategorySelectionEntity? v) =>
      emit(state.copyWith(componentSelection: v));

  // ===== Meta =====
  void setType(TypeCategorySelectionEntity v) => emit(state.copyWith(type: v));
  void setSearchKeywords(List<String> v) =>
      emit(state.copyWith(searchKeywords: List<String>.unmodifiable(v)));

  // Toggle staff
  void toggleTeamByEntity(StaffEntity m) {
    final exists = state.listTeam.any((e) => e.staffId == m.staffId);
    final updated = exists
        ? state.listTeam.where((e) => e.staffId != m.staffId).toList()
        : [...state.listTeam, m];
    emit(state.copyWith(listTeam: List<StaffEntity>.unmodifiable(updated)));
  }

  void setBLDate(DateTime? d) => emit(state.copyWith(blDate: d));
  void setArrivalDate(DateTime? d) => emit(state.copyWith(arrivalDate: d));

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  // ===== Hydrate dari Entity (prefill form dari PO yang ada) =====
  void hydrateFromEntity(PurchaseOrderEntity e) {
    emit(
      PurchaseOrderFormReq(
        projectId: e.projectId,
        invoiceId: e.invoiceId,
        purchaseOrderId: e.purchaseOrderId,
        purchaseContractNumber: e.purchaseContractNumber,
        projectName: e.projectName,
        projectCode: e.projectCode,
        projectStatus: e.projectStatus,
        currency: e.currency,
        price: e.price,
        quantity: e.quantity,
        customerName: e.customerName,
        customerCompany: e.customerCompany,
        customerContact: e.customerContact,
        productCategory: e.productCategory,
        productSelection: e.productSelection,
        componentSelection: e.componentSelection,
        type: e.type,
        searchKeywords: e.searchKeywords,
        blDate: e.blDate != null ? _dateOnly(e.blDate!.toDate()) : state.blDate,
        arrivalDate: e.arrivalDate != null
            ? _dateOnly(e.arrivalDate!.toDate())
            : state.arrivalDate,
      ),
    );
  }

  // ===== Reset =====
  void reset() => emit(const PurchaseOrderFormReq());
}
