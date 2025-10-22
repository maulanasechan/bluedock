import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';

abstract class PurchaseOrderDisplayState {}

class PurchaseOrderDisplayInitial extends PurchaseOrderDisplayState {}

class PurchaseOrderDisplayLoading extends PurchaseOrderDisplayState {}

class PurchaseOrderDisplayFetched extends PurchaseOrderDisplayState {
  final List<PurchaseOrderEntity> listPurchaseOrder;
  PurchaseOrderDisplayFetched({required this.listPurchaseOrder});
}

class PurchaseOrderDisplayFailure extends PurchaseOrderDisplayState {
  final String message;
  PurchaseOrderDisplayFailure({required this.message});
}

class PurchaseOrderDisplayOneFetched extends PurchaseOrderDisplayState {
  final PurchaseOrderEntity purchaseOrder;
  PurchaseOrderDisplayOneFetched({required this.purchaseOrder});
}
