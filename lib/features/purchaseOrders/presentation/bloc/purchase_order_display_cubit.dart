import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/get_purchase_order_by_id_usecase.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/search_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOrderDisplayCubit extends Cubit<PurchaseOrderDisplayState> {
  PurchaseOrderDisplayCubit() : super(PurchaseOrderDisplayInitial());

  int _reqId = 0;

  // ✅ filter internal selalu string ("" = no filter)
  String _type = '';
  String _keyword = '';

  // optional getter
  String get currentType => _type;
  String get currentKeyword => _keyword;

  // Boleh dipanggil tanpa params; kalau ada params, sync dulu internal filter
  Future<void> displayPurchaseOrder({SearchWithTypeReq? params}) async {
    if (params != null) {
      _type = params.type.trim();
      _keyword = params.keyword.trim();
    }

    final myReq = ++_reqId;
    emit(PurchaseOrderDisplayLoading());

    final req = SearchWithTypeReq(type: _type, keyword: _keyword);
    final returnedData = await sl<SearchPurchaseOrderUseCase>().call(
      params: req,
    );

    if (myReq != _reqId) return; // race guard

    returnedData.fold(
      (error) => emit(PurchaseOrderDisplayFailure(message: error.toString())),
      (data) => emit(PurchaseOrderDisplayFetched(listPurchaseOrder: data)),
    );
  }

  // Awal: boleh tanpa argumen ("" = all)
  void displayInitial([String? type]) {
    _type = (type ?? '').trim();
    _keyword = '';
    displayPurchaseOrder(); // pakai filter internal
  }

  // Set dari action button
  void setType(String? type) {
    _type = (type ?? '').trim();
    displayPurchaseOrder();
  }

  // Toggle: tekan type yang sama untuk clear (jadi "")
  void toggleType(String type) {
    final t = type.trim();
    _type = _type == t ? '' : t;
    displayPurchaseOrder();
  }

  // Set keyword dari search box
  void setKeyword(String? keyword) {
    _keyword = (keyword ?? '').trim();
    displayPurchaseOrder();
  }

  // Clear semua filter
  void clearFilters() {
    _type = '';
    _keyword = '';
    displayPurchaseOrder();
  }

  Future<void> displayPurchaseOrderById(String purchaseOrderId) async {
    final myReq = ++_reqId;
    emit(PurchaseOrderDisplayLoading());

    final result = await sl<GetPurchaseOrderByIdUseCase>().call(
      params: purchaseOrderId,
    );

    if (myReq != _reqId) return;

    result.fold(
      (err) => emit(PurchaseOrderDisplayFailure(message: err.toString())),
      (project) => emit(PurchaseOrderDisplayOneFetched(purchaseOrder: project)),
    );
  }
}
