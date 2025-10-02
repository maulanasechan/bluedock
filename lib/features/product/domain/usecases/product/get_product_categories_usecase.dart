import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/domain/repositories/product_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetProductCategoriesUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<ProductRepository>().getProductCategories();
  }
}
