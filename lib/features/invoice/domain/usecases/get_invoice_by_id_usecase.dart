import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetInvoiceByIdUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<InvoiceRepository>().getInvoiceById(params!);
  }
}
