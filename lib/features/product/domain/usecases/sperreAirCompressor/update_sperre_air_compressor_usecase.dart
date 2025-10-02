import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_form_req.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_air_compressor_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateSperreAirCompressorUseCase
    implements UseCase<Either, SperreAirCompressorReq> {
  @override
  Future<Either> call({SperreAirCompressorReq? params}) async {
    return await sl<SperreAirCompressorRepository>().updateSperreAirCompressor(
      params!,
    );
  }
}
