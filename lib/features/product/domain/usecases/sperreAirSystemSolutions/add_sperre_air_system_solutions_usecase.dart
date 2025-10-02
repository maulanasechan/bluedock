import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/data/models/sperreAirSystemSolutions/sperre_air_system_solutions_form_req.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_air_system_solutions_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class AddSperreAirSystemSolutionsUseCase
    implements UseCase<Either, SperreAirSystemSolutionsReq> {
  @override
  Future<Either> call({SperreAirSystemSolutionsReq? params}) async {
    return await sl<SperreAirSystemSolutionsRepository>()
        .addSperreAirSystemSolutions(params!);
  }
}
