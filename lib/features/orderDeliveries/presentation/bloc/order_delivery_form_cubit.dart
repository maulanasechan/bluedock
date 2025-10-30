import 'package:bluedock/features/orderDeliveries/data/models/order_delivery_form_req.dart';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';

class OrderDeliveryFormCubit extends Cubit<OrderDeliveryFormReq> {
  OrderDeliveryFormCubit() : super(const OrderDeliveryFormReq());

  // ----------------- Helpers: pad/trim lists -----------------

  List<InventoryEntity> _padComponents(
    int len, [
    List<InventoryEntity>? origin,
  ]) {
    final src = List<InventoryEntity>.from(origin ?? state.listComponent);
    if (src.length > len) src.removeRange(len, src.length);
    // kalau kurang dari len, biarkan: slot kosong = belum dipilih
    return List<InventoryEntity>.unmodifiable(src);
  }

  void _alignRowsTo(int len) {
    emit(
      state.copyWith(
        componentLength: len,
        listQuantity: _padQuantities(len),
        listComponent: _padComponents(len),
      ),
    );
  }

  // ----------------- Row controls (component + qty) -----------------
  /// Tambahkan semua komponen dari PO yang belum ada di state (beserta qty-nya).
  void addAllMissingFromPO() {
    final po = state.purchaseOrder;
    if (po == null) return;

    final existingIds = state.listComponent
        .map((e) => e.inventoryId)
        .where((id) => id.isNotEmpty)
        .toSet();

    final comps = List<InventoryEntity>.from(state.listComponent);
    final qtys = List<int>.from(state.listQuantity);

    for (var i = 0; i < po.listComponent.length; i++) {
      final inv = po.listComponent[i];
      final id = inv.inventoryId;
      if (id.isEmpty) continue;
      if (!existingIds.contains(id)) {
        comps.add(inv);
        qtys.add(i < po.quantity.length ? po.quantity[i] : 0);
        existingIds.add(id);
      }
    }

    final newLen = comps.isEmpty ? 1 : comps.length;
    emit(
      state.copyWith(
        componentLength: newLen,
        listComponent: List<InventoryEntity>.unmodifiable(
          _padComponents(newLen, comps),
        ),
        listQuantity: List<int>.unmodifiable(_padQuantities(newLen, qtys)),
      ),
    );
  }

  /// Tambahkan satu komponen “missing” berikutnya dari PO (return true kalau ada yang ditambah)
  bool addNextMissingFromPO() {
    final po = state.purchaseOrder;
    if (po == null) return false;

    final existingIds = state.listComponent
        .map((e) => e.inventoryId)
        .where((id) => id.isNotEmpty)
        .toSet();

    for (var i = 0; i < po.listComponent.length; i++) {
      final inv = po.listComponent[i];
      final id = inv.inventoryId;
      if (id.isEmpty) continue;
      if (!existingIds.contains(id)) {
        final comps = List<InventoryEntity>.from(state.listComponent)..add(inv);
        final qtys = List<int>.from(state.listQuantity)
          ..add(i < po.quantity.length ? po.quantity[i] : 0);

        final newLen = comps.isEmpty ? 1 : comps.length;
        emit(
          state.copyWith(
            componentLength: newLen,
            listComponent: List<InventoryEntity>.unmodifiable(
              _padComponents(newLen, comps),
            ),
            listQuantity: List<int>.unmodifiable(_padQuantities(newLen, qtys)),
          ),
        );
        return true;
      }
    }
    return false;
  }

  /// Override addComponent: utamakan ambil yang “missing” dari PO.
  /// Kalau sudah tidak ada yang missing, baru tambah baris kosong.
  void addComponent() {
    final added = addNextMissingFromPO();
    if (added) return; // sudah emit di atas

    final newLen = state.componentLength + 1;
    emit(
      state.copyWith(
        componentLength: newLen,
        listComponent: List<InventoryEntity>.unmodifiable(
          _padComponents(newLen),
        ),
        listQuantity: List<int>.unmodifiable(_padQuantities(newLen)),
      ),
    );
  }

  void removeLastComponent() {
    if (state.componentLength <= 1) return;
    _alignRowsTo(state.componentLength - 1);
  }

  void removeComponentAt(int index) {
    if (index < 0 || index >= state.componentLength) return;

    final q = List<int>.from(_padQuantities(state.componentLength));
    final comps = List<InventoryEntity>.from(
      _padComponents(state.componentLength),
    );

    q.removeAt(index);
    if (index < comps.length) comps.removeAt(index);

    emit(
      state.copyWith(
        componentLength: state.componentLength - 1,
        listQuantity: List<int>.unmodifiable(q),
        listComponent: List<InventoryEntity>.unmodifiable(comps),
      ),
    );
  }

  void clearAllComponentsAndQuantities() {
    emit(
      state.copyWith(
        componentLength: 1,
        listQuantity: const <int>[0],
        listComponent: const <InventoryEntity>[],
      ),
    );
  }

  // ----------------- Quantity per row -----------------
  void updateQuantityAt(int index, int value) {
    if (index < 0) return;
    final q = _padQuantities(state.componentLength);
    if (index >= q.length) return;
    q[index] = value;
    emit(state.copyWith(listQuantity: List<int>.unmodifiable(q)));
  }

  void clearQuantityAt(int index) => updateQuantityAt(index, 0);

  // ----------------- Component per row -----------------
  void setComponentAt(int index, InventoryEntity? inv) {
    if (index < 0 || index >= state.componentLength) return;

    final comps = List<InventoryEntity>.from(state.listComponent);

    if (inv == null) {
      if (index < comps.length) comps.removeAt(index);
    } else {
      if (index < comps.length) {
        comps[index] = inv;
      } else if (index == comps.length) {
        comps.add(inv);
      } else {
        return; // jangan paksakan padding loncat index
      }
    }

    emit(
      state.copyWith(listComponent: List<InventoryEntity>.unmodifiable(comps)),
    );
  }

  // ----------------- Linkage -----------------
  void setDeliveryOrderId(String v) => emit(state.copyWith(deliveryOrderId: v));

  // ----------------- Documents / Tracking -----------------
  void setTrackingId(String? v) => emit(state.copyWith(trackingId: v ?? ''));
  void setBLNumber(String? v) => emit(state.copyWith(blNumber: v ?? ''));

  // ----------------- Dates -----------------
  void setDeliveryDate(DateTime? ts) => emit(state.copyWith(deliveryDate: ts));
  void setEstimatedDate(DateTime? ts) =>
      emit(state.copyWith(estimatedDate: ts));

  // ----------------- Money -----------------
  void setCurrency(String v) => emit(state.copyWith(currency: v));
  void setPriceInt(int? v) => emit(state.copyWith(price: v));
  void setPriceFromText(String v) {
    final parsed = int.tryParse(v.trim());
    emit(state.copyWith(price: parsed));
  }

  // ----------------- Parties & Locations -----------------
  void setShipperCompany(String v) => emit(state.copyWith(shipperCompany: v));
  void setShipperContact(String v) => emit(state.copyWith(shipperContact: v));

  void setDischargeLocation(String v) =>
      emit(state.copyWith(dischargeLocation: v));
  void setArrivalLocation(String v) => emit(state.copyWith(arrivalLocation: v));

  // ----------------- Meta -----------------
  void setType(String v) =>
      emit(state.copyWith(type: v)); // 'inbound'/'outbound'
  void setStatus(String v) => emit(state.copyWith(status: v)); // 'Active', etc.

  void setSearchKeywords(List<String> v) =>
      emit(state.copyWith(searchKeywords: List<String>.unmodifiable(v)));

  // ----------------- Bulk setters -----------------
  // di OrderDeliveryFormCubit
  List<int> _padQuantities(int len, [List<int>? origin]) {
    final out = List<int>.from(origin ?? state.listQuantity);
    while (out.length < len) {
      out.add(0);
    }
    if (out.length > len) out.removeRange(len, out.length);
    return List<int>.unmodifiable(out);
  }

  void setPurchaseOrder(PurchaseOrderEntity v) {
    emit(state.copyWith(purchaseOrder: v));
  }

  void setComponentLength(int v) {
    emit(state.copyWith(componentLength: v));
  }

  /// Set komponen + samakan componentLength + pad quantity biar rapi
  void setListComponent(List<InventoryEntity> comps) {
    final len = comps.length;
    emit(
      state.copyWith(
        listComponent: List<InventoryEntity>.unmodifiable(comps),
        componentLength: len,
        listQuantity: _padQuantities(len, state.listQuantity),
      ),
    );
  }

  /// Kalau user ingin override quantity, tetap selaraskan panjangnya
  void setQuantityList(List<int> q) {
    final len = state.componentLength; // gunakan panjang komponen saat ini
    emit(
      state.copyWith(
        listQuantity: List<int>.unmodifiable(_padQuantities(len, q)),
      ),
    );
  }

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
        listQuantity: List<int>.unmodifiable(list.isEmpty ? const [0] : list),
        componentLength: (list.isEmpty ? 1 : list.length),
        listComponent: _padComponents(list.isEmpty ? 1 : list.length),
      ),
    );
  }

  // ----------------- Hydrate from entity -----------------
  void hydrateFromEntity(OrderDeliveryEntity e) {
    emit(
      state.copyWith(
        deliveryOrderId: e.deliveryOrderId,
        purchaseOrder: e.purchaseOrder,
        trackingId: e.trackingId ?? '',
        blNumber: e.blNumber ?? '',
        deliveryDate: e.deliveryDate.toDate(),
        estimatedDate: e.estimatedDate.toDate(),
        currency: e.currency,
        price: e.price,
        shipperCompany: e.shipperCompany,
        shipperContact: e.shipperContact,
        dischargeLocation: e.dischargeLocation,
        arrivalLocation: e.arrivalLocation,
        listComponent: List<InventoryEntity>.unmodifiable(e.listComponent),
        listQuantity: List<int>.unmodifiable(e.listQuantity),
        componentLength: e.listQuantity.isEmpty ? 1 : e.listQuantity.length,
        searchKeywords: List<String>.unmodifiable(e.searchKeywords),
        status: e.status,
        type: e.type,
      ),
    );
  }

  // ----------------- Reset -----------------
  void reset() => emit(const OrderDeliveryFormReq());
}
