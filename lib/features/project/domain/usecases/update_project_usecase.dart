import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/project/data/models/project_form_req.dart';
import 'package:bluedock/features/project/domain/repositories/project_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateProjectUseCase implements UseCase<Either, ProjectFormReq> {
  @override
  Future<Either> call({ProjectFormReq? params}) async {
    return await sl<ProjectRepository>().updateProject(params!);
  }
}
