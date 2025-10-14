import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/data/sources/product_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/product_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<Either> deleteProduct(ProductReq product) async {
    return await sl<ProductFirebaseService>().deleteProduct(product);
  }

  @override
  Future<Either> favoriteProduct(ProductReq product) async {
    return await sl<ProductFirebaseService>().favoriteProduct(product);
  }
}
