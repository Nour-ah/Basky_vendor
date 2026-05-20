import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_status.dart';
import '../entities/order_summary_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrdersUseCase {
  final OrdersRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderSummaryEntity>>> call({
    OrderStatus? status,
    int page = 1,
    int limit = 15,
  }) async {
    return await repository.getOrders(
      status: status,
      page: page,
      limit: limit,
    );
  }
}
