import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class PurchaseOrderRepository {
  Future<Either> searchPurchaseOrder(SearchWithTypeReq req);
  Future<Either> getPurchaseOrderById(String req);
  Future<Either> favoritePurchaseOrder(String req);
  Future<Either> updatePurchaseOrder(PurchaseOrderFormReq req);
  Future<Either> fillPurchaseOrder(PurchaseOrderFormReq req);
  Future<Either> addPurchaseOrder(PurchaseOrderFormReq req);
  Future<Either> deletePurchaseOrder(String req);
}
