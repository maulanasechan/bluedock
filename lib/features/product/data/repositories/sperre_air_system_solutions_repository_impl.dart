import 'package:bluedock/features/product/data/models/sperreAirSystemSolutions/sperre_air_system_solutions_form_req.dart';
import 'package:bluedock/features/product/data/models/sperreAirSystemSolutions/sperre_air_system_solutions_model.dart';
import 'package:bluedock/features/product/data/sources/sperre_air_system_solutions_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_air_system_solutions_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SperreAirSystemSolutionsRepositoryImpl
    extends SperreAirSystemSolutionsRepository {
  @override
  Future<Either> searchSperreAirSystemSolutions(String query) async {
    final res = await sl<SperreAirSystemSolutionsFirebaseService>()
        .searchSperreAirSystemSolutions(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(data)
            .map((e) => SperreAirSystemSolutionsModel.fromMap(e).toEntity())
            .toList(),
      ),
    );
  }

  @override
  Future<Either> addSperreAirSystemSolutions(
    SperreAirSystemSolutionsReq product,
  ) async {
    return await sl<SperreAirSystemSolutionsFirebaseService>()
        .addSperreAirSystemSolutions(product);
  }

  @override
  Future<Either> updateSperreAirSystemSolutions(
    SperreAirSystemSolutionsReq product,
  ) async {
    return await sl<SperreAirSystemSolutionsFirebaseService>()
        .updateSperreAirSystemSolutions(product);
  }
}
