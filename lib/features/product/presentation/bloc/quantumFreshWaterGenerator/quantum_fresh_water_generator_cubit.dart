import 'package:bluedock/features/product/domain/usecases/quantumFreshWaterGenerator/search_quantum_fresh_water_generator_usecase.dart';
import 'package:bluedock/features/product/presentation/bloc/quantumFreshWaterGenerator/quantum_fresh_water_generator_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuantumFreshWaterGeneratorCubit
    extends Cubit<QuantumFreshWaterGeneratorState> {
  QuantumFreshWaterGeneratorCubit()
    : super(QuantumFreshWaterGeneratorInitial());
  int _reqId = 0;

  void displayQuantumFreshWaterGenerator({String? params}) async {
    final myReq = ++_reqId;
    emit(QuantumFreshWaterGeneratorLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<SearchQuantumFreshWaterGeneratorUseCase>().call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(QuantumFreshWaterGeneratorFailure());
      },
      (data) {
        emit(
          QuantumFreshWaterGeneratorFetched(quantumFreshWaterGenerator: data),
        );
      },
    );
  }

  void displayInitial() {
    displayQuantumFreshWaterGenerator(params: '');
  }
}
