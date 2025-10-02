import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_air_system_solutions_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SearchSperreAirSystemSolutionsUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<SperreAirSystemSolutionsRepository>()
        .searchSperreAirSystemSolutions(params!);
  }
}
