import 'package:bluedock/common/data/models/product/product_selection_req.dart';
import 'package:bluedock/common/domain/repositories/product_section_repository.dart';
import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetProductSelectionUseCase
    implements UseCase<Either, ProductSelectionReq> {
  @override
  Future<Either> call({ProductSelectionReq? params}) async {
    return await sl<ProductSectionRepository>().getProductSelection(params!);
  }
}
