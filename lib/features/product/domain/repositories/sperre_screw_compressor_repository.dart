import 'package:bluedock/features/product/data/models/sperreScrewCompressor/sperre_screw_compressor_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class SperreScrewCompressorRepository {
  Future<Either> searchSperreScrewCompressor(String query);
  Future<Either> addSperreScrewCompressor(SperreScrewCompressorReq product);
  Future<Either> updateSperreScrewCompressor(SperreScrewCompressorReq product);
}
