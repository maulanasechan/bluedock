import 'package:bluedock/features/product/domain/usecases/sperreScrewCompressor/search_sperre_screw_compressor_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreScrewCompressor/sperre_screw_compressor_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SperreScrewCompressorCubit extends Cubit<SperreScrewCompressorState> {
  SperreScrewCompressorCubit() : super(SperreScrewCompressorInitial());
  int _reqId = 0;

  void displaySperreScrewCompressor({String? params}) async {
    final myReq = ++_reqId;
    emit(SperreScrewCompressorLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<SearchSperreScrewCompressorUseCase>().call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(SperreScrewCompressorFailure());
      },
      (data) {
        emit(SperreScrewCompressorFetched(sperreScrewCompressor: data));
      },
    );
  }

  void displayInitial() {
    displaySperreScrewCompressor(params: '');
  }
}
