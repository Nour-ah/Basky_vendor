import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_invoice_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrderInvoiceUseCase {
  final OrdersRepository repository;

  GetOrderInvoiceUseCase(this.repository);

  Future<Either<Failure, OrderInvoiceEntity>> call(int orderId) {
    return repository.getOrderInvoice(orderId);
  }
}
