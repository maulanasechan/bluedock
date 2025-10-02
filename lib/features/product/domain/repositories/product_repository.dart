import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/data/models/selection/selection_req.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either> getProductCategories();
  Future<Either> deleteProduct(ProductReq product);
  Future<Either> favoriteProduct(ProductReq product);
  Future<Either> getSelection(SelectionReq selection);
}
