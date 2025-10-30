import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/orderDeliveries/domain/repositories/order_delivery_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class FavoriteOrderDeliveryUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<OrderDeliveryRepository>().favoriteOrderDelivery(params!);
  }
}
