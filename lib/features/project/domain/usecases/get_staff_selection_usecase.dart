import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/project/domain/repositories/project_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetStaffSelectionUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<ProjectRepository>().getStaffSelection(params!);
  }
}
