import 'package:equatable/equatable.dart';
import '../../domain/entities/order_invoice_entity.dart';

abstract class OrderInvoiceState extends Equatable {
  const OrderInvoiceState();

  @override
  List<Object?> get props => [];
}

class OrderInvoiceInitial extends OrderInvoiceState {}

class OrderInvoiceLoading extends OrderInvoiceState {}

class OrderInvoiceLoaded extends OrderInvoiceState {
  final OrderInvoiceEntity invoice;

  const OrderInvoiceLoaded(this.invoice);

  @override
  List<Object?> get props => [invoice];
}

class OrderInvoiceError extends OrderInvoiceState {
  final String message;
  final bool isNetworkError;

  const OrderInvoiceError(this.message, {this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}
