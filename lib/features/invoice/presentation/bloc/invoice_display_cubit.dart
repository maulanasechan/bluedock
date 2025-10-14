import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/invoice/domain/usecases/get_invoice_by_id_usecase.dart';
import 'package:bluedock/features/invoice/domain/usecases/search_invoice_usecase.dart';
import 'package:bluedock/features/invoice/presentation/bloc/invoice_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceDisplayCubit extends Cubit<InvoiceDisplayState> {
  InvoiceDisplayCubit() : super(InvoiceDisplayInitial());

  int _reqId = 0;

  // ✅ filter internal selalu string ("" = no filter)
  String _type = '';
  String _keyword = '';

  // optional getter
  String get currentType => _type;
  String get currentKeyword => _keyword;

  // Boleh dipanggil tanpa params; kalau ada params, sync dulu internal filter
  Future<void> displayInvoice({SearchWithTypeReq? params}) async {
    if (params != null) {
      _type = params.type.trim();
      _keyword = params.keyword.trim();
    }

    final myReq = ++_reqId;
    emit(InvoiceDisplayLoading());

    final req = SearchWithTypeReq(type: _type, keyword: _keyword);
    final returnedData = await sl<SearchInvoiceUseCase>().call(params: req);

    if (myReq != _reqId) return; // race guard

    returnedData.fold(
      (error) => emit(InvoiceDisplayFailure(message: error.toString())),
      (data) => emit(InvoiceDisplayFetched(listInvoice: data)),
    );
  }

  // Awal: boleh tanpa argumen ("" = all)
  void displayInitial([String? type]) {
    _type = (type ?? '').trim();
    _keyword = '';
    displayInvoice(); // pakai filter internal
  }

  // Set dari action button
  void setType(String? type) {
    _type = (type ?? '').trim();
    displayInvoice();
  }

  // Toggle: tekan type yang sama untuk clear (jadi "")
  void toggleType(String type) {
    final t = type.trim();
    _type = _type == t ? '' : t;
    displayInvoice();
  }

  // Set keyword dari search box
  void setKeyword(String? keyword) {
    _keyword = (keyword ?? '').trim();
    displayInvoice();
  }

  // Clear semua filter
  void clearFilters() {
    _type = '';
    _keyword = '';
    displayInvoice();
  }

  Future<void> displayInvoiceById(String invoiceId) async {
    final myReq = ++_reqId;
    emit(InvoiceDisplayLoading());

    final result = await sl<GetInvoiceByIdUseCase>().call(params: invoiceId);

    if (myReq != _reqId) return;

    result.fold(
      (err) => emit(InvoiceDisplayFailure(message: err.toString())),
      (invoice) => emit(InvoiceDisplayOneFetched(invoice: invoice)),
    );
  }
}
