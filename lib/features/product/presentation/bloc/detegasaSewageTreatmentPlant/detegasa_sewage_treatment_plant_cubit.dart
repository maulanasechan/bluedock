import 'package:bluedock/features/product/domain/usecases/detegasaSewageTreatmentPlant/search_detegasa_sewage_treatment_plant_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/detegasaSewageTreatmentPlant/detegasa_sewage_treatment_plant_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetegasaSewageTreatmentPlantCubit
    extends Cubit<DetegasaSewageTreatmentPlantState> {
  DetegasaSewageTreatmentPlantCubit()
    : super(DetegasaSewageTreatmentPlantInitial());
  int _reqId = 0;

  void displayDetegasaSewageTreatmentPlant({String? params}) async {
    final myReq = ++_reqId;
    emit(DetegasaSewageTreatmentPlantLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<SearchDetegasaSewageTreatmentPlantUseCase>()
        .call(params: params);
    returnedData.fold(
      (error) {
        emit(DetegasaSewageTreatmentPlantFailure());
      },
      (data) {
        emit(
          DetegasaSewageTreatmentPlantFetched(
            detegasaSewageTreatmentPlant: data,
          ),
        );
      },
    );
  }

  void displayInitial() {
    displayDetegasaSewageTreatmentPlant(params: '');
  }
}
