import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/data/models/detegasaSewageTreatmentPlant/detegasa_sewage_treatment_plant_form_req.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_sewage_treatment_plant_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateDetegasaSewageTreatmentPlantUseCase
    implements UseCase<Either, DetegasaSewageTreatmentPlantReq> {
  @override
  Future<Either> call({DetegasaSewageTreatmentPlantReq? params}) async {
    return await sl<DetegasaSewageTreatmentPlantRepository>()
        .updateDetegasaSewageTreatmentPlant(params!);
  }
}
