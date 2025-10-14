import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';
import 'package:dartz/dartz.dart';

abstract class InvoiceRepository {
  Future<Either> searchInvoice(SearchWithTypeReq req);
  Future<Either> getInvoiceById(String req);
  Future<Either> favoriteInvoice(String req);
  Future<Either> paidInvoice(InvoiceEntity req);
}
