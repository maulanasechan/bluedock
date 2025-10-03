import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_oily_water_separator_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SearchDetegasaOilyWaterSeparatorUseCase
    implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<DetegasaOilyWaterSeparatorRepository>()
        .searchDetegasaOilyWaterSeparator(params!);
  }
}
