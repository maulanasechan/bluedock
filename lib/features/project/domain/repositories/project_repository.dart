import 'package:bluedock/features/project/data/models/project/project_form_req.dart';
import 'package:bluedock/features/project/data/models/selection/product_selection_req.dart';
import 'package:bluedock/features/project/domain/entities/project_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProjectRepository {
  Future<Either> getProjectSelection(String selection);
  Future<Either> getCategorySelection();
  Future<Either> getProductSelection(ProductSelectionReq req);
  Future<Either> getStaffSelection(String req);
  Future<Either> addProject(ProjectFormReq req);
  Future<Either> updateProject(ProjectFormReq req);
  Future<Either> searchProject(String req);
  Future<Either> deleteProject(ProjectEntity req);
  Future<Either> favoriteProject(String req);
}
