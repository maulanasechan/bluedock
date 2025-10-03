import 'package:bluedock/features/product/domain/usecases/detegasaIncenerator/search_detegasa_incenerator_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaIncenerator/detegasa_incenerator_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetegasaInceneratorCubit extends Cubit<DetegasaInceneratorState> {
  DetegasaInceneratorCubit() : super(DetegasaInceneratorInitial());
  int _reqId = 0;

  void displayDetegasaIncenerator({String? params}) async {
    final myReq = ++_reqId;
    emit(DetegasaInceneratorLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<SearchDetegasaInceneratorUseCase>().call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(DetegasaInceneratorFailure());
      },
      (data) {
        emit(DetegasaInceneratorFetched(detegasaIncenerator: data));
      },
    );
  }

  void displayInitial() {
    displayDetegasaIncenerator(params: '');
  }
}
