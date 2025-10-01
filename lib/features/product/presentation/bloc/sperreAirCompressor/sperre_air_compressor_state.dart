import 'package:bluedock/features/product/domain/entities/sperre_air_compressor_entity.dart';

abstract class SperreAirCompressorState {}

class SperreAirCompressorInitial extends SperreAirCompressorState {}

class SperreAirCompressorLoading extends SperreAirCompressorState {}

class SperreAirCompressorFetched extends SperreAirCompressorState {
  final List<SperreAirCompressorEntity> sperreAirCompressor;
  SperreAirCompressorFetched({required this.sperreAirCompressor});
}

class SperreAirCompressorFailure extends SperreAirCompressorState {}
