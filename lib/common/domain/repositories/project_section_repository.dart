import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:dartz/dartz.dart';

abstract class ProjectSectionRepository {
  Future<Either> searchProject(SearchWithTypeReq req);
  Future<Either> getProjectById(String req);
}
