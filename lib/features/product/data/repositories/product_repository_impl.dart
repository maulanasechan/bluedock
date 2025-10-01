import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/data/models/productCategories/product_categories_model.dart';
import 'package:bluedock/features/product/data/models/selection/selection_model.dart';
import 'package:bluedock/features/product/data/models/selection/selection_req.dart';
import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_form_req.dart';
import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_model.dart';
import 'package:bluedock/features/product/data/sources/product_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/product_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class ProductRepositoryImpl extends ProductRepository {
  // Selection
  @override
  Future<Either> getSelection(SelectionReq selection) async {
    var returnedData = await sl<ProductFirebaseService>().getSelection(
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
          ).map((e) => SelectionModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  // Product Categories
  @override
  Future<Either> getProductCategories() async {
    var returnedData = await sl<ProductFirebaseService>()
        .getProductCategories();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductCategoriesModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  // Sperre Air Compressor
  @override
  Future<Either> searchSperreAirCompressor(String query) async {
    final res = await sl<ProductFirebaseService>().searchSperreAirCompressor(
      query,
    );
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(
          data,
        ).map((e) => SperreAirCompressorModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> addSperreAirCompressor(SperreAirCompressorReq product) async {
    return await sl<ProductFirebaseService>().addSperreAirCompressor(product);
  }

  @override
  Future<Either> updateSperreAirCompressor(
    SperreAirCompressorReq product,
  ) async {
    return await sl<ProductFirebaseService>().updateSperreAirCompressor(
      product,
    );
  }

  @override
  Future<Either> deleteProduct(ProductReq product) async {
    return await sl<ProductFirebaseService>().deleteProduct(product);
  }
}
