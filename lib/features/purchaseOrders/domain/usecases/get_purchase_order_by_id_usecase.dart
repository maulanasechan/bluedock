import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/purchaseOrders/domain/repositories/purchase_order_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetPurchaseOrderByIdUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<PurchaseOrderRepository>().getPurchaseOrderById(params!);
  }
}
