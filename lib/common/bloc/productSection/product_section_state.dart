import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';

abstract class ProductSectionState {}

class ProductSectionLoading extends ProductSectionState {}

class ProductCategoryFetched extends ProductSectionState {
  final List<ProductCategoryEntity> productCategory;
  ProductCategoryFetched({required this.productCategory});
}

class ProductSectionFailure extends ProductSectionState {
  final String message;

  ProductSectionFailure({required this.message});
}

class ProductSelectionFetched extends ProductSectionState {
  final List<ProductSelectionEntity> productSelection;
  ProductSelectionFetched({required this.productSelection});
}
