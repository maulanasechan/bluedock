import 'package:bluedock/features/product/data/models/detegasaSewageTreatmentPlant/detegasa_sewage_treatment_plant_form_req.dart';
import 'package:bluedock/features/product/data/models/detegasaSewageTreatmentPlant/detegasa_sewage_treatment_plant_model.dart';
import 'package:bluedock/features/product/data/sources/detegasa_sewage_treatment_plant_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_sewage_treatment_plant_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class DetegasaSewageTreatmentPlantRepositoryImpl
    extends DetegasaSewageTreatmentPlantRepository {
  @override
  Future<Either> searchDetegasaSewageTreatmentPlant(String query) async {
    final res = await sl<DetegasaSewageTreatmentPlantFirebaseService>()
        .searchDetegasaSewageTreatmentPlant(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(data)
            .map((e) => DetegasaSewageTreatmentPlantModel.fromMap(e).toEntity())
            .toList(),
      ),
    );
  }

  @override
  Future<Either> addDetegasaSewageTreatmentPlant(
    DetegasaSewageTreatmentPlantReq product,
  ) async {
    return await sl<DetegasaSewageTreatmentPlantFirebaseService>()
        .addDetegasaSewageTreatmentPlant(product);
  }

  @override
  Future<Either> updateDetegasaSewageTreatmentPlant(
    DetegasaSewageTreatmentPlantReq product,
  ) async {
    return await sl<DetegasaSewageTreatmentPlantFirebaseService>()
        .updateDetegasaSewageTreatmentPlant(product);
  }
}
