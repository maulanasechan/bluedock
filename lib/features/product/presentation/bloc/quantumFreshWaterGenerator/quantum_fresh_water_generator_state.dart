import 'package:bluedock/features/product/domain/entities/quantum_fresh_water_generator_entity.dart';

abstract class QuantumFreshWaterGeneratorState {}

class QuantumFreshWaterGeneratorInitial
    extends QuantumFreshWaterGeneratorState {}

class QuantumFreshWaterGeneratorLoading
    extends QuantumFreshWaterGeneratorState {}

class QuantumFreshWaterGeneratorFetched
    extends QuantumFreshWaterGeneratorState {
  final List<QuantumFreshWaterGeneratorEntity> quantumFreshWaterGenerator;
  QuantumFreshWaterGeneratorFetched({required this.quantumFreshWaterGenerator});
}

class QuantumFreshWaterGeneratorFailure
    extends QuantumFreshWaterGeneratorState {}
