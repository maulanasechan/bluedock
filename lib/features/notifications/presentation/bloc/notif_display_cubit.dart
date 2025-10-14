import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/notifications/domain/usecases/search_notif_usecase.dart';
import 'package:bluedock/features/notifications/presentation/bloc/notif_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifDisplayCubit extends Cubit<NotifDisplayState> {
  NotifDisplayCubit() : super(NotifDisplayInitial());

  int _reqId = 0;

  // ✅ filter internal selalu string ("" = no filter)
  String _type = '';
  String _keyword = '';

  // optional getter
  String get currentType => _type;
  String get currentKeyword => _keyword;

  // Boleh dipanggil tanpa params; kalau ada params, sync dulu internal filter
  Future<void> displayNotif({SearchWithTypeReq? params}) async {
    if (params != null) {
      _type = params.type.trim();
      _keyword = params.keyword.trim();
    }

    final myReq = ++_reqId;
    emit(NotifDisplayLoading());

    final req = SearchWithTypeReq(type: _type, keyword: _keyword);
    final returnedData = await sl<SearchNotifUseCase>().call(params: req);

    if (myReq != _reqId) return; // race guard

    returnedData.fold(
      (error) => emit(NotifDisplayFailure(message: error.toString())),
      (data) => emit(NotifDisplayFetched(listNotif: data)),
    );
  }

  // Awal: boleh tanpa argumen ("" = all)
  void displayInitial([String? type]) {
    _type = (type ?? '').trim();
    _keyword = '';
    displayNotif(); // pakai filter internal
  }

  // Set dari action button
  void setType(String? type) {
    _type = (type ?? '').trim();
    displayNotif();
  }

  // Toggle: tekan type yang sama untuk clear (jadi "")
  void toggleType(String type) {
    final t = type.trim();
    _type = _type == t ? '' : t;
    displayNotif();
  }

  // Set keyword dari search box
  void setKeyword(String? keyword) {
    _keyword = (keyword ?? '').trim();
    displayNotif();
  }

  // Clear semua filter
  void clearFilters() {
    _type = '';
    _keyword = '';
    displayNotif();
  }
}
