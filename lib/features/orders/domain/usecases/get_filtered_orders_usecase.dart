import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_filter_result_entity.dart';
import '../entities/order_status.dart';
import '../repositories/orders_repository.dart';

class GetFilteredOrdersUseCase {
  final OrdersRepository repository;

  GetFilteredOrdersUseCase(this.repository);

  Future<Either<Failure, OrderFilterResultEntity>> call({
    OrderStatus? status,
    int page = 1,
    int limit = 15,
  }) async {
    return await repository.getFilteredOrders(
      status: status,
      page: page,
      limit: limit,
    );
  }
}
