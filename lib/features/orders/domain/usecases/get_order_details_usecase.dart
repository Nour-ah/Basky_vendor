import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_details_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrderDetailsUseCase {
  final OrdersRepository repository;

  GetOrderDetailsUseCase(this.repository);

  Future<Either<Failure, OrderDetailsEntity>> call(int orderId) async {
    return await repository.getOrderDetails(orderId);
  }
}
