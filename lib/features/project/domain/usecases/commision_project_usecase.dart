import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/project/domain/repositories/project_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class CommisionProjectUseCase implements UseCase<Either, ProjectEntity> {
  @override
  Future<Either> call({ProjectEntity? params}) async {
    return await sl<ProjectRepository>().commisionProject(params!);
  }
}
