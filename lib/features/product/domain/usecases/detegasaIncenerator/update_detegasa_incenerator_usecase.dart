import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/data/models/detegasaIncenerator/detegasa_incenerator_form_req.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_incenerator_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateDetegasaInceneratorUseCase
    implements UseCase<Either, DetegasaInceneratorReq> {
  @override
  Future<Either> call({DetegasaInceneratorReq? params}) async {
    return await sl<DetegasaInceneratorRepository>().updateDetegasaIncenerator(
      params!,
    );
  }
}
