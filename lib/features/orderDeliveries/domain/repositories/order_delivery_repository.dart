import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/orderDeliveries/data/models/order_delivery_form_req.dart';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:dartz/dartz.dart';

abstract class OrderDeliveryRepository {
  Future<Either> searchOrderDelivery(SearchWithTypeReq req);
  Future<Either> getOrderDeliveryById(String req);
  Future<Either> favoriteOrderDelivery(String req);
  Future<Either> updateOrderDelivery(OrderDeliveryFormReq req);
  Future<Either> createOrderDelivery(OrderDeliveryFormReq req);
  Future<Either> deleteOrderDelivery(OrderDeliveryEntity req);
  Future<Either> completeOrderDelivery(OrderDeliveryEntity req);
}
