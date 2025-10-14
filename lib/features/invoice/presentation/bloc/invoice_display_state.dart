import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';

abstract class InvoiceDisplayState {}

class InvoiceDisplayInitial extends InvoiceDisplayState {}

class InvoiceDisplayLoading extends InvoiceDisplayState {}

class InvoiceDisplayFetched extends InvoiceDisplayState {
  final List<InvoiceEntity> listInvoice;
  InvoiceDisplayFetched({required this.listInvoice});
}

class InvoiceDisplayFailure extends InvoiceDisplayState {
  final String message;
  InvoiceDisplayFailure({required this.message});
}

class InvoiceDisplayOneFetched extends InvoiceDisplayState {
  final InvoiceEntity invoice;
  InvoiceDisplayOneFetched({required this.invoice});
}
