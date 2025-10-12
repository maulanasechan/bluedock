import 'package:bluedock/common/data/models/product/product_selection_model.dart';
import 'package:bluedock/common/data/models/product/product_selection_req.dart';
import 'package:bluedock/common/data/models/productCategory/product_category_model.dart';
import 'package:bluedock/common/data/sources/product_section_firebase_service.dart';
import 'package:bluedock/common/domain/repositories/product_section_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class ProductSectionRepositoryImpl extends ProductSectionRepository {
  @override
  Future<Either> getProductCategories() async {
    var returnedData = await sl<ProductSectionFirebaseService>()
        .getProductCategories();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductCategoryModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getProductSelection(ProductSelectionReq req) async {
    var returnedData = await sl<ProductSectionFirebaseService>()
        .getProductSelection(req);
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
