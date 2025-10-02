import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/domain/repositories/quantum_fresh_water_generator_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SearchQuantumFreshWaterGeneratorUseCase
    implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<QuantumFreshWaterGeneratorRepository>()
        .searchQuantumFreshWaterGenerator(params!);
  }
}
