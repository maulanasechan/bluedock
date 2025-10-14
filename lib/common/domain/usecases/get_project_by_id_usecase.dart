import 'package:bluedock/common/domain/repositories/project_section_repository.dart';
import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetProjectByIdUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<ProjectSectionRepository>().getProjectById(params!);
  }
}
