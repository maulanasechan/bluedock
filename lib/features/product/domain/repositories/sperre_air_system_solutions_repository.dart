import 'package:bluedock/features/product/data/models/sperreAirSystemSolutions/sperre_air_system_solutions_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class SperreAirSystemSolutionsRepository {
  Future<Either> searchSperreAirSystemSolutions(String query);
  Future<Either> addSperreAirSystemSolutions(
    SperreAirSystemSolutionsReq product,
  );
  Future<Either> updateSperreAirSystemSolutions(
    SperreAirSystemSolutionsReq product,
  );
}
