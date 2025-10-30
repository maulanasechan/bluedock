import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';

abstract class OrderDeliveryDisplayState {}

class OrderDeliveryDisplayInitial extends OrderDeliveryDisplayState {}

class OrderDeliveryDisplayLoading extends OrderDeliveryDisplayState {}

class OrderDeliveryDisplayFetched extends OrderDeliveryDisplayState {
  final List<OrderDeliveryEntity> listOrderDelivery;
  OrderDeliveryDisplayFetched({required this.listOrderDelivery});
}

class OrderDeliveryDisplayFailure extends OrderDeliveryDisplayState {
  final String message;
  OrderDeliveryDisplayFailure({required this.message});
}

class OrderDeliveryDisplayOneFetched extends OrderDeliveryDisplayState {
  final OrderDeliveryEntity orderDelivery;
  OrderDeliveryDisplayOneFetched({required this.orderDelivery});
}
