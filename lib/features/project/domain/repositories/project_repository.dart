import 'package:bluedock/features/project/data/models/selection/product_selection_req.dart';
import 'package:dartz/dartz.dart';

abstract class ProjectRepository {
  Future<Either> getProjectSelection(String selection);
  Future<Either> getCategorySelection();
  Future<Either> getProductSelection(ProductSelectionReq req);
}
