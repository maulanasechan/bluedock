import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';
import 'package:bluedock/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class PaidInvoiceUseCase implements UseCase<Either, InvoiceEntity> {
  @override
  Future<Either> call({InvoiceEntity? params}) async {
    return await sl<InvoiceRepository>().paidInvoice(params!);
  }
}
