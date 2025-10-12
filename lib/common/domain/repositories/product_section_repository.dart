import 'package:bluedock/common/data/models/product/product_selection_req.dart';
import 'package:dartz/dartz.dart';

abstract class ProductSectionRepository {
  Future<Either> getProductCategories();
  Future<Either> getProductSelection(ProductSelectionReq req);
}
