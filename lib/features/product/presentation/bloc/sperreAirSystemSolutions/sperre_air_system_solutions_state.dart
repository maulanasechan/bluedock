import 'package:bluedock/features/product/domain/entities/sperre_air_system_solutions_entity.dart';

abstract class SperreAirSystemSolutionsState {}

class SperreAirSystemSolutionsInitial extends SperreAirSystemSolutionsState {}

class SperreAirSystemSolutionsLoading extends SperreAirSystemSolutionsState {}

class SperreAirSystemSolutionsFetched extends SperreAirSystemSolutionsState {
  final List<SperreAirSystemSolutionsEntity> sperreAirSystemSolutions;
  SperreAirSystemSolutionsFetched({required this.sperreAirSystemSolutions});
}

class SperreAirSystemSolutionsFailure extends SperreAirSystemSolutionsState {}
