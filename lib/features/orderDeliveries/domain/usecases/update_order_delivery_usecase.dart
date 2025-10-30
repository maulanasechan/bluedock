import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/orderDeliveries/data/models/order_delivery_form_req.dart';
import 'package:bluedock/features/orderDeliveries/domain/repositories/order_delivery_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateOrderDeliveryUseCase
    implements UseCase<Either, OrderDeliveryFormReq> {
  @override
  Future<Either> call({OrderDeliveryFormReq? params}) async {
    return await sl<OrderDeliveryRepository>().updateOrderDelivery(params!);
  }
}
