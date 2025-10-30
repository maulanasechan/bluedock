import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/orderDeliveries/domain/usecases/get_order_delivery_by_id_usecase.dart';
import 'package:bluedock/features/orderDeliveries/domain/usecases/search_order_delivery_usecase.dart';
import 'package:bluedock/features/orderDeliveries/presentation/bloc/order_delivery_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDeliveryDisplayCubit extends Cubit<OrderDeliveryDisplayState> {
  OrderDeliveryDisplayCubit() : super(OrderDeliveryDisplayInitial());

  int _reqId = 0;

  // ✅ filter internal selalu string ("" = no filter)
  String _type = '';
  String _keyword = '';

  // optional getter
  String get currentType => _type;
  String get currentKeyword => _keyword;

  // Boleh dipanggil tanpa params; kalau ada params, sync dulu internal filter
  Future<void> displayOrderDelivery({SearchWithTypeReq? params}) async {
    if (params != null) {
      _type = params.type.trim();
      _keyword = params.keyword.trim();
    }

    final myReq = ++_reqId;
    emit(OrderDeliveryDisplayLoading());

    final req = SearchWithTypeReq(type: _type, keyword: _keyword);
    final returnedData = await sl<SearchOrderDeliveryUseCase>().call(
      params: req,
    );

    if (myReq != _reqId) return; // race guard

    returnedData.fold(
      (error) => emit(OrderDeliveryDisplayFailure(message: error.toString())),
      (data) => emit(OrderDeliveryDisplayFetched(listOrderDelivery: data)),
    );
  }

  // Awal: boleh tanpa argumen ("" = all)
  void displayInitial([String? type]) {
    _type = (type ?? '').trim();
    _keyword = '';
    displayOrderDelivery(); // pakai filter internal
  }

  // Set dari action button
  void setType(String? type) {
    _type = (type ?? '').trim();
    displayOrderDelivery();
  }

  // Toggle: tekan type yang sama untuk clear (jadi "")
  void toggleType(String type) {
    final t = type.trim();
    _type = _type == t ? '' : t;
    displayOrderDelivery();
  }

  // Set keyword dari search box
  void setKeyword(String? keyword) {
    _keyword = (keyword ?? '').trim();
    displayOrderDelivery();
  }

  // Clear semua filter
  void clearFilters() {
    _type = '';
    _keyword = '';
    displayOrderDelivery();
  }

  Future<void> displayOrderDeliveryById(String deliveryOrderId) async {
    final myReq = ++_reqId;
    emit(OrderDeliveryDisplayLoading());

    final result = await sl<GetOrderDeliveryByIdUseCase>().call(
      params: deliveryOrderId,
    );

    if (myReq != _reqId) return;

    result.fold(
      (err) => emit(OrderDeliveryDisplayFailure(message: err.toString())),
      (data) => emit(OrderDeliveryDisplayOneFetched(orderDelivery: data)),
    );
  }
}
