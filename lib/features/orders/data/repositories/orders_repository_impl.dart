import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_details_entity.dart';
import '../../domain/entities/order_filter_result_entity.dart';
import '../../domain/entities/order_invoice_entity.dart';
import '../../domain/entities/order_realtime_event.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/order_summary_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_realtime_datasource.dart';
import '../datasources/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final OrdersRealtimeDataSource realtimeDataSource;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.realtimeDataSource,
  });

  @override
  Future<Either<Failure, List<OrderSummaryEntity>>> getOrders({
    OrderStatus? status,
    int page = 1,
    int limit = 15,
  }) async {
    return _execute(() => remoteDataSource.getOrders(status: status, page: page, limit: limit));
  }

  @override
  Future<Either<Failure, OrderFilterResultEntity>> getFilteredOrders({
    OrderStatus? status,
    int page = 1,
    int limit = 15,
  }) async {
    return _execute(() => remoteDataSource.getFilteredOrders(status: status, page: page, limit: limit));
  }

  @override
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails(int orderId) async {
    return _execute(() => remoteDataSource.getOrderDetails(orderId));
  }

  @override
  Future<Either<Failure, OrderInvoiceEntity>> getOrderInvoice(int orderId) async {
    return _execute(() => remoteDataSource.getOrderInvoice(orderId));
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus({
    required int orderId,
    required OrderStatus newStatus,
  }) async {
    return _execute(() => remoteDataSource.updateOrderStatus(orderId: orderId, newStatus: newStatus));
  }

  @override
  Stream<OrderRealtimeEvent> watchNewVendorOrders() =>
      realtimeDataSource.watchNewVendorOrders();

  @override
  Stream<OrderRealtimeEvent> watchOrderStatus(int platformOrderId) =>
      realtimeDataSource.watchOrderStatus(platformOrderId);

  @override
  Stream<OrderRealtimeEvent> watchOrdersStatus(Iterable<int> platformOrderIds) =>
      realtimeDataSource.watchOrdersStatus(platformOrderIds);

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
