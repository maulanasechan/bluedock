import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/product/data/models/selection/selection_req.dart';
import 'package:bluedock/features/product/domain/repositories/product_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetSelectionUseCase implements UseCase<Either, SelectionReq> {
  @override
  Future<Either> call({SelectionReq? params}) async {
    return await sl<ProductRepository>().getSelection(params!);
  }
}
