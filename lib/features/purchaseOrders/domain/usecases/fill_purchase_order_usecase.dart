import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:bluedock/features/purchaseOrders/domain/repositories/purchase_order_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class FillPurchaseOrderUseCase
    implements UseCase<Either, PurchaseOrderFormReq> {
  @override
  Future<Either> call({PurchaseOrderFormReq? params}) async {
    return await sl<PurchaseOrderRepository>().fillPurchaseOrder(params!);
  }
}
