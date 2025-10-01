import 'package:bluedock/features/product/domain/entities/product_categories_entity.dart';

abstract class ProductCategoriesState {}

class ProductCategoriesLoading extends ProductCategoriesState {}

class ProductCategoriesFetched extends ProductCategoriesState {
  final List<ProductCategoriesEntity> productCategories;
  ProductCategoriesFetched({required this.productCategories});
}

class ProductCategoriesFailure extends ProductCategoriesState {}
