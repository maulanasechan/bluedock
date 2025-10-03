import 'package:bluedock/features/product/data/models/detegasaIncenerator/detegasa_incenerator_form_req.dart';
import 'package:bluedock/features/product/data/models/detegasaIncenerator/detegasa_incenerator_model.dart';
import 'package:bluedock/features/product/data/sources/detegasa_incenerator_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_incenerator_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class DetegasaInceneratorRepositoryImpl extends DetegasaInceneratorRepository {
  @override
  Future<Either> searchDetegasaIncenerator(String query) async {
    final res = await sl<DetegasaInceneratorFirebaseService>()
        .searchDetegasaIncenerator(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(
          data,
        ).map((e) => DetegasaInceneratorModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> addDetegasaIncenerator(DetegasaInceneratorReq product) async {
    return await sl<DetegasaInceneratorFirebaseService>()
        .addDetegasaIncenerator(product);
  }

  @override
  Future<Either> updateDetegasaIncenerator(
    DetegasaInceneratorReq product,
  ) async {
    return await sl<DetegasaInceneratorFirebaseService>()
        .updateDetegasaIncenerator(product);
  }
}
