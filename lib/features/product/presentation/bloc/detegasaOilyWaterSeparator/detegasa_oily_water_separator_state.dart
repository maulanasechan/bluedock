import 'package:bluedock/features/product/domain/entities/detegasa_oily_water_separator_entity.dart';

abstract class DetegasaOilyWaterSeparatorState {}

class DetegasaOilyWaterSeparatorInitial
    extends DetegasaOilyWaterSeparatorState {}

class DetegasaOilyWaterSeparatorLoading
    extends DetegasaOilyWaterSeparatorState {}

class DetegasaOilyWaterSeparatorFetched
    extends DetegasaOilyWaterSeparatorState {
  final List<DetegasaOilyWaterSeparatorEntity> detegasaOilyWaterSeparator;
  DetegasaOilyWaterSeparatorFetched({required this.detegasaOilyWaterSeparator});
}

class DetegasaOilyWaterSeparatorFailure
    extends DetegasaOilyWaterSeparatorState {}
