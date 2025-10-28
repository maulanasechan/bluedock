import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_model.dart';
import 'package:bluedock/features/purchaseOrders/data/sources/purchase_order_firebase_service.dart';
import 'package:bluedock/features/purchaseOrders/domain/repositories/purchase_order_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class PurchaseOrderRepositoryImpl extends PurchaseOrderRepository {
  @override
  Future<Either> searchPurchaseOrder(SearchWithTypeReq query) async {
    final res = await sl<PurchaseOrderFirebaseService>().searchPurchaseOrder(
      query,
    );
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(
          data,
        ).map((e) => PurchaseOrderModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> getPurchaseOrderById(String req) async {
    final res = await sl<PurchaseOrderFirebaseService>().getPurchaseOrderById(
      req,
    );
    return res.fold(
      (err) => Left(err),
      (m) => Right(PurchaseOrderModel.fromMap(m).toEntity()),
    );
  }

  @override
  Future<Either> favoritePurchaseOrder(String req) async {
    return await sl<PurchaseOrderFirebaseService>().favoritePurchaseOrder(req);
  }

  @override
  Future<Either> deletePurchaseOrder(String req) async {
    return await sl<PurchaseOrderFirebaseService>().deletePurchaseOrder(req);
  }

  @override
  Future<Either> addPurchaseOrder(PurchaseOrderFormReq req) async {
    return await sl<PurchaseOrderFirebaseService>().addPurchaseOrder(req);
  }

  @override
  Future<Either> updatePurchaseOrder(PurchaseOrderFormReq req) async {
    return await sl<PurchaseOrderFirebaseService>().updatePurchaseOrder(req);
  }
}
