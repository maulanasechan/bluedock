import 'package:bluedock/features/product/data/models/quantumFreshWaterGenerator/quantum_fresh_water_generator_form_req.dart';
import 'package:bluedock/features/product/data/models/quantumFreshWaterGenerator/quantum_fresh_water_generator_model.dart';
import 'package:bluedock/features/product/data/sources/quantum_fresh_water_generator_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/quantum_fresh_water_generator_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class QuantumFreshWaterGeneratorRepositoryImpl
    extends QuantumFreshWaterGeneratorRepository {
  @override
  Future<Either> searchQuantumFreshWaterGenerator(String query) async {
    final res = await sl<QuantumFreshWaterGeneratorFirebaseService>()
        .searchQuantumFreshWaterGenerator(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(data)
            .map((e) => QuantumFreshWaterGeneratorModel.fromMap(e).toEntity())
            .toList(),
      ),
    );
  }

  @override
  Future<Either> addQuantumFreshWaterGenerator(
    QuantumFreshWaterGeneratorReq product,
  ) async {
    return await sl<QuantumFreshWaterGeneratorFirebaseService>()
        .addQuantumFreshWaterGenerator(product);
  }

  @override
  Future<Either> updateQuantumFreshWaterGenerator(
    QuantumFreshWaterGeneratorReq product,
  ) async {
    return await sl<QuantumFreshWaterGeneratorFirebaseService>()
        .updateQuantumFreshWaterGenerator(product);
  }
}
