import 'package:bluedock/features/project/domain/entities/selection/product_selection_entity.dart';
import 'package:bluedock/features/project/domain/entities/selection/category_selection_entity.dart';
import 'package:bluedock/features/project/domain/entities/selection/project_selection_entity.dart';

abstract class ProjectSelectionDisplayState {}

class ProjectSelectionDisplayLoading extends ProjectSelectionDisplayState {}

class ProjectSelectionDisplayFetched extends ProjectSelectionDisplayState {
  final List<ProjectSelectionEntity> listSelection;

  ProjectSelectionDisplayFetched({required this.listSelection});
}

class ProjectSelectionDisplayFailure extends ProjectSelectionDisplayState {
  final String message;

  ProjectSelectionDisplayFailure({required this.message});
}

class CategorySelectionDisplayFetched extends ProjectSelectionDisplayState {
  final List<CategorySelectionEntity> listSelection;

  CategorySelectionDisplayFetched({required this.listSelection});
}

class ProductSelectionDisplayFetched extends ProjectSelectionDisplayState {
  final List<ProductSelectionEntity> listSelection;

  ProductSelectionDisplayFetched({required this.listSelection});
}
