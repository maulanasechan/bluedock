import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/invoice/data/models/invoice_model.dart';
import 'package:bluedock/features/invoice/data/sources/invoice_firebase_service.dart';
import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';
import 'package:bluedock/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class InvoiceRepositoryImpl extends InvoiceRepository {
  @override
  Future<Either> searchInvoice(SearchWithTypeReq query) async {
    final res = await sl<InvoiceFirebaseService>().searchInvoice(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(data).map((e) => InvoiceModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> getInvoiceById(String invoiceId) async {
    final res = await sl<InvoiceFirebaseService>().getInvoiceById(invoiceId);
    return res.fold(
      (err) => Left(err),
      (m) => Right(InvoiceModel.fromMap(m).toEntity()),
    );
  }

  @override
  Future<Either> favoriteInvoice(String req) async {
    return await sl<InvoiceFirebaseService>().favoriteInvoice(req);
  }

  @override
  Future<Either> paidInvoice(InvoiceEntity invoice) async {
    return await sl<InvoiceFirebaseService>().paidInvoice(invoice);
  }
}
