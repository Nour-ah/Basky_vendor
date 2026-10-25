import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/order_filter_result_entity.dart';
import '../repositories/orders_repository.dart';

/// Maps a platform `order_id` (shown as #41) to the vendor-orders row `id`
/// required by `GET /vendor/orders/{id}`.
///
/// Notification payloads send platform `order_id`, while list/details APIs use
/// the vendor order row `id` (e.g. list item `{id: 58, order_id: 41}`).
class ResolveVendorOrderIdUseCase {
  ResolveVendorOrderIdUseCase(this.repository);

  final OrdersRepository repository;

  static const int _pageSize = 50;
  static const int _maxPages = 10;

  Future<Either<Failure, int>> call(int candidateId) async {
    if (candidateId <= 0) {
      return const Left(ServerFailure('Invalid order id'));
    }

    for (var page = 1; page <= _maxPages; page++) {
      final result = await repository.getFilteredOrders(
        page: page,
        limit: _pageSize,
      );

      Failure? failure;
      OrderFilterResultEntity? pageResult;
      result.fold((f) => failure = f, (r) => pageResult = r);

      if (failure != null) return Left(failure!);

      final orders = pageResult!.orders;
      for (final order in orders) {
        if (order.id == candidateId ||
            order.orderCode == candidateId.toString()) {
          return Right(order.id);
        }
      }

      if (pageResult!.hasReachedMax || orders.isEmpty) break;
    }

    return Left(
      ServerFailure('Vendor order not found for order #$candidateId'),
    );
  }
}
