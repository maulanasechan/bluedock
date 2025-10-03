import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/data/models/detegasaOilyWaterSeparator/detegasa_oily_water_separator_form_req.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_oily_water_separator_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class AddDetegasaOilyWaterSeparatorUseCase
    implements UseCase<Either, DetegasaOilyWaterSeparatorReq> {
  @override
  Future<Either> call({DetegasaOilyWaterSeparatorReq? params}) async {
    return await sl<DetegasaOilyWaterSeparatorRepository>()
        .addDetegasaOilyWaterSeparator(params!);
  }
}
