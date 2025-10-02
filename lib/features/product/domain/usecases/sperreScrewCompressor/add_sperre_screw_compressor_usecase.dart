import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/data/models/sperreScrewCompressor/sperre_screw_compressor_form_req.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_screw_compressor_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class AddSperreScrewCompressorUseCase
    implements UseCase<Either, SperreScrewCompressorReq> {
  @override
  Future<Either> call({SperreScrewCompressorReq? params}) async {
    return await sl<SperreScrewCompressorRepository>().addSperreScrewCompressor(
      params!,
    );
  }
}
