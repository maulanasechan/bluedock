import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/orderDeliveries/data/models/order_delivery_form_req.dart';
import 'package:bluedock/features/orderDeliveries/data/models/order_delivery_model.dart';
import 'package:bluedock/features/orderDeliveries/data/sources/order_delivery_firebase_service.dart';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:bluedock/features/orderDeliveries/domain/repositories/order_delivery_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class OrderDeliveryRepositoryImpl extends OrderDeliveryRepository {
  @override
  Future<Either> searchOrderDelivery(SearchWithTypeReq query) async {
    final res = await sl<OrderDeliveryFirebaseService>().searchOrderDelivery(
      query,
    );
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(
          data,
        ).map((e) => OrderDeliveryModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> getOrderDeliveryById(String req) async {
    final res = await sl<OrderDeliveryFirebaseService>().getOrderDeliveryById(
      req,
    );
    return res.fold(
      (err) => Left(err),
      (m) => Right(OrderDeliveryModel.fromMap(m).toEntity()),
    );
  }

  @override
  Future<Either> favoriteOrderDelivery(String req) async {
    return await sl<OrderDeliveryFirebaseService>().favoriteOrderDelivery(req);
  }

  @override
  Future<Either> deleteOrderDelivery(OrderDeliveryEntity req) async {
    return await sl<OrderDeliveryFirebaseService>().deleteOrderDelivery(req);
  }

  @override
  Future<Either> createOrderDelivery(OrderDeliveryFormReq req) async {
    return await sl<OrderDeliveryFirebaseService>().createOrderDelivery(req);
  }

  @override
  Future<Either> updateOrderDelivery(OrderDeliveryFormReq req) async {
    return await sl<OrderDeliveryFirebaseService>().updateOrderDelivery(req);
  }

  @override
  Future<Either> completeOrderDelivery(OrderDeliveryEntity req) async {
    return await sl<OrderDeliveryFirebaseService>().completeOrderDelivery(req);
  }
}
