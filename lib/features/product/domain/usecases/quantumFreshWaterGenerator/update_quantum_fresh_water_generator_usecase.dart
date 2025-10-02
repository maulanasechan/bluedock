import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/data/models/quantumFreshWaterGenerator/quantum_fresh_water_generator_form_req.dart';
import 'package:bluedock/features/product/domain/repositories/quantum_fresh_water_generator_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateQuantumFreshWaterGeneratorUseCase
    implements UseCase<Either, QuantumFreshWaterGeneratorReq> {
  @override
  Future<Either> call({QuantumFreshWaterGeneratorReq? params}) async {
    return await sl<QuantumFreshWaterGeneratorRepository>()
        .updateQuantumFreshWaterGenerator(params!);
  }
}
