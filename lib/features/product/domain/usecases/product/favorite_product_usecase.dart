import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/domain/repositories/product_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class FavoriteProductUseCase implements UseCase<Either, ProductReq> {
  @override
  Future<Either> call({ProductReq? params}) async {
    return await sl<ProductRepository>().favoriteProduct(params!);
  }
}
