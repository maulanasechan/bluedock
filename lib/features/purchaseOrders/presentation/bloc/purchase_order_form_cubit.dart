import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';

class PurchaseOrderFormCubit extends Cubit<PurchaseOrderFormReq> {
  PurchaseOrderFormCubit() : super(const PurchaseOrderFormReq());

  List<int> _fitQuantities(int len, [List<int>? origin]) {
    final src = List<int>.from(origin ?? state.quantity);
    if (src.length > len) {
      src.removeRange(len, src.length);
    }
    return src;
  }

  // ------------ SETTERS UTAMA ------------
  void addComponent() {
    emit(state.copyWith(componentLength: state.componentLength + 1));
  }

  void removeLastComponent() {
    if (state.componentLength <= 1) return;
    final nextLen = state.componentLength - 1;
    emit(
      state.copyWith(
        componentLength: nextLen,
        quantity: List<int>.unmodifiable(_fitQuantities(nextLen)),
      ),
    );
  }

  void removeComponentAt(int index) {
    if (index < 0 || index >= state.componentLength) return;

    final q = List<int>.from(state.quantity);
    if (index < q.length) q.removeAt(index);

    final comps = List<InventoryEntity>.from(state.listComponent);
    if (index < comps.length) comps.removeAt(index);

    emit(
      state.copyWith(
        componentLength: state.componentLength - 1,
        quantity: List<int>.unmodifiable(q),
        listComponent: List<InventoryEntity>.unmodifiable(comps),
      ),
    );
  }

  void clearAllComponentsAndQuantities() {
    emit(
      state.copyWith(
        componentLength: 1,
        quantity: const <int>[0],
        listComponent: const <InventoryEntity>[],
      ),
    );
  }

  // ------------ QUANTITY PER-BARIS ------------
  void updateQuantityAt(int index, int value) {
    if (index < 0) return;
    final q = List<int>.from(state.quantity); // mutable

    while (q.length <= index) {
      q.add(0);
    }

    q[index] = value;
    emit(state.copyWith(quantity: List<int>.unmodifiable(q)));
  }

  void clearQuantityAt(int index) {
    updateQuantityAt(index, 0);
  }

  // ------------ COMPONENT PER-BARIS ------------
  void setComponentAt(int index, InventoryEntity? inv) {
    // index mesti valid terhadap jumlah baris yang tampil
    if (index < 0 || index >= state.componentLength) return;

    final comps = List<InventoryEntity>.from(state.listComponent);

    if (inv == null) {
      // hapus slot yang ada (kalau memang ada)
      if (index < comps.length) {
        comps.removeAt(index);
      }
    } else {
      if (index < comps.length) {
        comps[index] = inv;
      } else if (index == comps.length) {
        comps.add(inv);
      } else {
        // index > length: jangan dipaksa padding karena tipe non-null
        return;
      }
    }

    emit(
      state.copyWith(listComponent: List<InventoryEntity>.unmodifiable(comps)),
    );
  }

  // ===== IDs & linkage =====
  void setProject(project) => emit(state.copyWith(project: project));
  void setPOName(String v) => emit(state.copyWith(poName: v));
  void setPurchaseOrderId(String v) => emit(state.copyWith(purchaseOrderId: v));

  // ===== Project & contract (yang tersisa) =====
  void setCurrency(String v) => emit(state.copyWith(currency: v));

  /// price nullable: setter dari int & dari text
  void setPriceInt(int? v) => emit(state.copyWith(price: v));
  void setPriceFromText(String v) {
    final parsed = int.tryParse(v.trim());
    emit(state.copyWith(price: parsed)); // bisa null kalau parse gagal
  }

  // ===== Quantity: sekarang List<int> =====
  void setQuantityList(List<int> q) =>
      emit(state.copyWith(quantity: List<int>.unmodifiable(q)));

  void setQuantityFromTextList(String v) {
    final parts = v
        .split(RegExp(r'[;,]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty);
    final list = <int>[];
    for (final p in parts) {
      final x = int.tryParse(p);
      if (x != null) list.add(x);
    }
    emit(
      state.copyWith(
        quantity: List<int>.unmodifiable(list.isEmpty ? const [0] : list),
      ),
    );
  }

  void addComponentLength() =>
      emit(state.copyWith(componentLength: state.componentLength + 1));
  void minusComponentLength() =>
      emit(state.copyWith(componentLength: state.componentLength - 1));

  void addQuantity(int value) =>
      emit(state.copyWith(quantity: [...state.quantity, value]));

  void removeQuantityAt(int index) {
    if (index < 0 || index >= state.quantity.length) return;
    final next = [...state.quantity]..removeAt(index);
    emit(
      state.copyWith(
        quantity: List<int>.unmodifiable(next.isEmpty ? const [0] : next),
      ),
    );
  }

  // ===== Seller =====
  void setSellerName(String v) => emit(state.copyWith(sellerName: v));
  void setSellerCompany(String v) => emit(state.copyWith(sellerCompany: v));
  void setSellerContact(String v) => emit(state.copyWith(sellerContact: v));

  // ===== Selections =====
  void setProductCategory(ProductCategoryEntity v) =>
      emit(state.copyWith(productCategory: v));
  void setProductSelection(ProductSelectionEntity v) =>
      emit(state.copyWith(productSelection: v));

  void toggleComponentByEntity(InventoryEntity m) {
    final exists = state.listComponent.any(
      (e) => e.inventoryId == m.inventoryId,
    );

    final updated = exists
        ? state.listComponent
              .where((e) => e.inventoryId != m.inventoryId)
              .toList()
        : [...state.listComponent, m];

    emit(
      state.copyWith(
        listComponent: List<InventoryEntity>.unmodifiable(updated),
      ),
    );
  }

  // ===== Meta =====
  void setType(TypeCategorySelectionEntity v) => emit(state.copyWith(type: v));
  void setSearchKeywords(List<String> v) =>
      emit(state.copyWith(searchKeywords: List<String>.unmodifiable(v)));

  void hydrateFromEntity(PurchaseOrderEntity e) {
    List<int> q;
    final dynQ = (e as dynamic).quantity;
    if (dynQ is List<int>) {
      q = dynQ;
    } else if (dynQ is int) {
      q = <int>[dynQ];
    } else {
      q = const <int>[0];
    }

    emit(
      PurchaseOrderFormReq(
        project: e.project,
        purchaseOrderId: e.purchaseOrderId,
        currency: e.currency,
        price: e.price,
        quantity: q,
        sellerName: e.sellerName,
        sellerCompany: e.sellerCompany,
        sellerContact: e.sellerContact,
        productCategory: e.productCategory,
        productSelection: e.productSelection,
        listComponent: e.listComponent,
        type: e.type,
        componentLength: e.listComponent.length,
        searchKeywords: e.searchKeywords,
      ),
    );
  }

  // ===== Reset =====
  void reset() => emit(const PurchaseOrderFormReq());
}
