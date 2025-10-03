import 'package:bluedock/features/product/domain/entities/detegasa_sewage_treatment_plant_entity.dart';

abstract class DetegasaSewageTreatmentPlantState {}

class DetegasaSewageTreatmentPlantInitial
    extends DetegasaSewageTreatmentPlantState {}

class DetegasaSewageTreatmentPlantLoading
    extends DetegasaSewageTreatmentPlantState {}

class DetegasaSewageTreatmentPlantFetched
    extends DetegasaSewageTreatmentPlantState {
  final List<DetegasaSewageTreatmentPlantEntity> detegasaSewageTreatmentPlant;
  DetegasaSewageTreatmentPlantFetched({
    required this.detegasaSewageTreatmentPlant,
  });
}

class DetegasaSewageTreatmentPlantFailure
    extends DetegasaSewageTreatmentPlantState {}
