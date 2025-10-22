import 'package:bluedock/features/project/data/models/project_form_req.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProjectRepository {
  Future<Either> addProject(ProjectFormReq req);
  Future<Either> updateProject(ProjectFormReq req);
  Future<Either> deleteProject(ProjectEntity req);
  Future<Either> favoriteProject(String req);
  Future<Either> commisionProject(ProjectEntity req);
}
