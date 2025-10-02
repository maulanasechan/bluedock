import 'package:bluedock/features/product/domain/entities/sperre_screw_compressor_entity.dart';

abstract class SperreScrewCompressorState {}

class SperreScrewCompressorInitial extends SperreScrewCompressorState {}

class SperreScrewCompressorLoading extends SperreScrewCompressorState {}

class SperreScrewCompressorFetched extends SperreScrewCompressorState {
  final List<SperreScrewCompressorEntity> sperreScrewCompressor;
  SperreScrewCompressorFetched({required this.sperreScrewCompressor});
}

class SperreScrewCompressorFailure extends SperreScrewCompressorState {}
