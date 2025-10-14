import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/common/data/sources/project_section_firebase_service.dart';
import 'package:bluedock/common/domain/repositories/project_section_repository.dart';
import 'package:bluedock/common/data/models/project/project_model.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class ProjectSectionRepositoryImpl extends ProjectSectionRepository {
  @override
  Future<Either> searchProject(SearchWithTypeReq query) async {
    final res = await sl<ProjectSectionFirebaseService>().searchProject(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(data).map((e) => ProjectModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> getProjectById(String projectId) async {
    final res = await sl<ProjectSectionFirebaseService>().getProjectById(
      projectId,
    );
    return res.fold(
      (err) => Left(err),
      (m) => Right(ProjectModel.fromMap(m).toEntity()),
    );
  }
}
