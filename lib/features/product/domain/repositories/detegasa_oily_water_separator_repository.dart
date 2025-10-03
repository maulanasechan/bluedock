import 'package:bluedock/features/product/data/models/detegasaOilyWaterSeparator/detegasa_oily_water_separator_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class DetegasaOilyWaterSeparatorRepository {
  Future<Either> searchDetegasaOilyWaterSeparator(String query);
  Future<Either> addDetegasaOilyWaterSeparator(
    DetegasaOilyWaterSeparatorReq product,
  );
  Future<Either> updateDetegasaOilyWaterSeparator(
    DetegasaOilyWaterSeparatorReq product,
  );
}
