import 'package:bluedock/features/product/domain/entities/detegasa_incenerator_entity.dart';

abstract class DetegasaInceneratorState {}

class DetegasaInceneratorInitial extends DetegasaInceneratorState {}

class DetegasaInceneratorLoading extends DetegasaInceneratorState {}

class DetegasaInceneratorFetched extends DetegasaInceneratorState {
  final List<DetegasaInceneratorEntity> detegasaIncenerator;
  DetegasaInceneratorFetched({required this.detegasaIncenerator});
}

class DetegasaInceneratorFailure extends DetegasaInceneratorState {}
