import 'package:bluedock/features/product/data/models/quantumFreshWaterGenerator/quantum_fresh_water_generator_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class QuantumFreshWaterGeneratorRepository {
  Future<Either> searchQuantumFreshWaterGenerator(String query);
  Future<Either> addQuantumFreshWaterGenerator(
    QuantumFreshWaterGeneratorReq product,
  );
  Future<Either> updateQuantumFreshWaterGenerator(
    QuantumFreshWaterGeneratorReq product,
  );
}
