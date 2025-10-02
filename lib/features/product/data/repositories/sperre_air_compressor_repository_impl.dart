import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_form_req.dart';
import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_model.dart';
import 'package:bluedock/features/product/data/sources/sperre_air_compressor_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_air_compressor_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SperreAirCompressorRepositoryImpl extends SperreAirCompressorRepository {
  @override
  Future<Either> searchSperreAirCompressor(String query) async {
    final res = await sl<SperreAirCompressorFirebaseService>()
        .searchSperreAirCompressor(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(
          data,
        ).map((e) => SperreAirCompressorModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> addSperreAirCompressor(SperreAirCompressorReq product) async {
    return await sl<SperreAirCompressorFirebaseService>()
        .addSperreAirCompressor(product);
  }

  @override
  Future<Either> updateSperreAirCompressor(
    SperreAirCompressorReq product,
  ) async {
    return await sl<SperreAirCompressorFirebaseService>()
        .updateSperreAirCompressor(product);
  }
}
