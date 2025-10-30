import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:bluedock/features/orderDeliveries/domain/repositories/order_delivery_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class CompleteOrderDeliveryUseCase
    implements UseCase<Either, OrderDeliveryEntity> {
  @override
  Future<Either> call({OrderDeliveryEntity? params}) async {
    return await sl<OrderDeliveryRepository>().completeOrderDelivery(params!);
  }
}
