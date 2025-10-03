import 'package:bluedock/features/product/data/models/detegasaOilyWaterSeparator/detegasa_oily_water_separator_form_req.dart';
import 'package:bluedock/features/product/data/models/detegasaOilyWaterSeparator/detegasa_oily_water_separator_model.dart';
import 'package:bluedock/features/product/data/sources/detegasa_oily_water_separator_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_oily_water_separator_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class DetegasaOilyWaterSeparatorRepositoryImpl
    extends DetegasaOilyWaterSeparatorRepository {
  @override
  Future<Either> searchDetegasaOilyWaterSeparator(String query) async {
    final res = await sl<DetegasaOilyWaterSeparatorFirebaseService>()
        .searchDetegasaOilyWaterSeparator(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(data)
            .map((e) => DetegasaOilyWaterSeparatorModel.fromMap(e).toEntity())
            .toList(),
      ),
    );
  }

  @override
  Future<Either> addDetegasaOilyWaterSeparator(
    DetegasaOilyWaterSeparatorReq product,
  ) async {
    return await sl<DetegasaOilyWaterSeparatorFirebaseService>()
        .addDetegasaOilyWaterSeparator(product);
  }

  @override
  Future<Either> updateDetegasaOilyWaterSeparator(
    DetegasaOilyWaterSeparatorReq product,
  ) async {
    return await sl<DetegasaOilyWaterSeparatorFirebaseService>()
        .updateDetegasaOilyWaterSeparator(product);
  }
}
