import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_sewage_treatment_plant_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SearchDetegasaSewageTreatmentPlantUseCase
    implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<DetegasaSewageTreatmentPlantRepository>()
        .searchDetegasaSewageTreatmentPlant(params!);
  }
}
