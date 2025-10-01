import 'package:bluedock/features/product/domain/usecases/sperreAirCompressor/search_sperre_air_compressor_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/sperreAirCompressor/sperre_air_compressor_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SperreAirCompressorCubit extends Cubit<SperreAirCompressorState> {
  SperreAirCompressorCubit() : super(SperreAirCompressorInitial());

  void displaySperreAirCompressor({String? params}) async {
    emit(SperreAirCompressorLoading());
    var returnedData = await sl<SearchSperreAirCompressorUseCase>().call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(SperreAirCompressorFailure());
      },
      (data) {
        emit(SperreAirCompressorFetched(sperreAirCompressor: data));
      },
    );
  }

  void displayInitial() {
    displaySperreAirCompressor(params: '');
  }
}
