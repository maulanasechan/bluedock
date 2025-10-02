import 'package:bluedock/features/product/data/models/sperreScrewCompressor/sperre_screw_compressor_form_req.dart';
import 'package:bluedock/features/product/data/models/sperreScrewCompressor/sperre_screw_compressor_model.dart';
import 'package:bluedock/features/product/data/sources/sperre_screw_compressor_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_screw_compressor_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SperreSrewCompressorRepositoryImpl
    extends SperreScrewCompressorRepository {
  @override
  Future<Either> searchSperreScrewCompressor(String query) async {
    final res = await sl<SperreScrewCompressorFirebaseService>()
        .searchSperreScrewCompressor(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(
          data,
        ).map((e) => SperreScrewCompressorModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> addSperreScrewCompressor(
    SperreScrewCompressorReq product,
  ) async {
    return await sl<SperreScrewCompressorFirebaseService>()
        .addSperreScrewCompressor(product);
  }

  @override
  Future<Either> updateSperreScrewCompressor(
    SperreScrewCompressorReq product,
  ) async {
    return await sl<SperreScrewCompressorFirebaseService>()
        .updateSperreScrewCompressor(product);
  }
}
