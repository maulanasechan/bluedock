import 'package:bluedock/features/project/data/models/project_form_req.dart';
import 'package:bluedock/features/project/data/sources/project_firebase_service.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/features/project/domain/repositories/project_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class ProjectRepositoryImpl extends ProjectRepository {
  @override
  Future<Either> addProject(ProjectFormReq project) async {
    return await sl<ProjectFirebaseService>().addProject(project);
  }

  @override
  Future<Either> updateProject(ProjectFormReq project) async {
    return await sl<ProjectFirebaseService>().updateProject(project);
  }

  @override
  Future<Either> deleteProject(ProjectEntity req) async {
    return await sl<ProjectFirebaseService>().deleteProject(req);
  }

  @override
  Future<Either> favoriteProject(String req) async {
    return await sl<ProjectFirebaseService>().favoriteProject(req);
  }

  @override
  Future<Either> endProject(ProjectEntity project) async {
    return await sl<ProjectFirebaseService>().endProject(project);
  }
}
