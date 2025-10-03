import 'package:bluedock/features/product/data/models/detegasaSewageTreatmentPlant/detegasa_sewage_treatment_plant_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class DetegasaSewageTreatmentPlantRepository {
  Future<Either> searchDetegasaSewageTreatmentPlant(String query);
  Future<Either> addDetegasaSewageTreatmentPlant(
    DetegasaSewageTreatmentPlantReq product,
  );
  Future<Either> updateDetegasaSewageTreatmentPlant(
    DetegasaSewageTreatmentPlantReq product,
  );
}
