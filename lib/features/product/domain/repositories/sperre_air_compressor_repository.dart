import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class SperreAirCompressorRepository {
  Future<Either> searchSperreAirCompressor(String query);
  Future<Either> addSperreAirCompressor(SperreAirCompressorReq product);
  Future<Either> updateSperreAirCompressor(SperreAirCompressorReq product);
}
