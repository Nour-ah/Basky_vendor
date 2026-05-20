import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_status.dart';
import '../repositories/orders_repository.dart';

class UpdateOrderStatusUseCase {
  final OrdersRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required int orderId,
    required OrderStatus newStatus,
  }) async {
    return await repository.updateOrderStatus(
      orderId: orderId,
      newStatus: newStatus,
    );
  }
}
