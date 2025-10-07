import 'package:bluedock/features/project/data/models/selection/category_selection_model.dart';
import 'package:bluedock/features/project/data/models/selection/product_selection_model.dart';
import 'package:bluedock/features/project/data/models/selection/product_selection_req.dart';
import 'package:bluedock/features/project/data/models/selection/project_selection_model.dart';
import 'package:bluedock/features/project/data/sources/project_firebase_service.dart';
import 'package:bluedock/features/project/domain/repositories/project_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class ProjectRepositoryImpl extends ProjectRepository {
  // Selection
  @override
  Future<Either> getProjectSelection(String selection) async {
    var returnedData = await sl<ProjectFirebaseService>().getProjectSelection(
      selection,
    );
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProjectSelectionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  // Categories
  @override
  Future<Either> getCategorySelection() async {
    var returnedData = await sl<ProjectFirebaseService>()
        .getCategorySelection();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => CategorySelectionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  // Product
  @override
  Future<Either> getProductSelection(ProductSelectionReq req) async {
    var returnedData = await sl<ProjectFirebaseService>().getProductSelection(
      req,
    );
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductSelectionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }
}
