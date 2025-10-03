import 'package:bluedock/features/product/domain/usecases/detegasaOilyWaterSeparator/search_detegasa_oily_water_separator_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaOilyWaterSeparator/detegasa_oily_water_separator_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetegasaOilyWaterSeparatorCubit
    extends Cubit<DetegasaOilyWaterSeparatorState> {
  DetegasaOilyWaterSeparatorCubit()
    : super(DetegasaOilyWaterSeparatorInitial());
  int _reqId = 0;

  void displayDetegasaOilyWaterSeparator({String? params}) async {
    final myReq = ++_reqId;
    emit(DetegasaOilyWaterSeparatorLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<SearchDetegasaOilyWaterSeparatorUseCase>().call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(DetegasaOilyWaterSeparatorFailure());
      },
      (data) {
        emit(
          DetegasaOilyWaterSeparatorFetched(detegasaOilyWaterSeparator: data),
        );
      },
    );
  }

  void displayInitial() {
    displayDetegasaOilyWaterSeparator(params: '');
  }
}
