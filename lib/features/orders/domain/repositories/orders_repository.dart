import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_details_entity.dart';
import '../entities/order_filter_result_entity.dart';
import '../entities/order_invoice_entity.dart';
import '../entities/order_realtime_event.dart';
import '../entities/order_status.dart';
import '../entities/order_summary_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderSummaryEntity>>> getOrders({
    OrderStatus? status,
    int page = 1,
    int limit = 15,
  });

  Future<Either<Failure, OrderFilterResultEntity>> getFilteredOrders({
    OrderStatus? status,
    int page = 1,
    int limit = 15,
  });

  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails(int orderId);

  Future<Either<Failure, OrderInvoiceEntity>> getOrderInvoice(int orderId);

  Future<Either<Failure, void>> updateOrderStatus({
    required int orderId,
    required OrderStatus newStatus,
  });

  Stream<OrderRealtimeEvent> watchNewVendorOrders();

  Stream<OrderRealtimeEvent> watchOrderStatus(int platformOrderId);

  Stream<OrderRealtimeEvent> watchOrdersStatus(Iterable<int> platformOrderIds);
}
