import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/realtime/realtime_refresh_mixin.dart';
import '../../domain/entities/order_details_entity.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../domain/usecases/watch_order_status_usecase.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState>
    with RealtimeRefreshMixin<OrderDetailsState> {
  final GetOrderDetailsUseCase getOrderDetailsUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final WatchOrderStatusUseCase watchOrderStatusUseCase;

  int? _watchedPlatformOrderId;

  OrderDetailsCubit({
    required this.getOrderDetailsUseCase,
    required this.updateOrderStatusUseCase,
    required this.watchOrderStatusUseCase,
  }) : super(OrderDetailsInitial());

  Future<void> fetchOrderDetails(int orderId) async {
    if (isClosed) return;
    emit(OrderDetailsLoading());

    final result = await getOrderDetailsUseCase(orderId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        OrderDetailsError(
          failure.message,
          isNetworkError: failure is NetworkFailure,
        ),
      ),
      (order) {
        emit(OrderDetailsLoaded(order));
        _watchStatus(order);
      },
    );
  }

  void _watchStatus(OrderDetailsEntity order) {
    final platformOrderId = order.platformOrderId;
    if (platformOrderId == null || platformOrderId == _watchedPlatformOrderId) {
      return;
    }
    _watchedPlatformOrderId = platformOrderId;
    listenForRealtimeRefresh(
      watchOrderStatusUseCase(platformOrderId),
      () => _refreshSilently(order.id),
    );
  }

  /// Refetches details after a realtime status change; skipped while the
  /// vendor is updating the status, failures keep the current screen.
  Future<void> _refreshSilently(int orderId) async {
    if (isClosed || state is! OrderDetailsLoaded) return;

    final result = await getOrderDetailsUseCase(orderId);
    if (isClosed || state is! OrderDetailsLoaded) return;

    result.fold(
      (_) {},
      (order) => emit(OrderDetailsLoaded(order)),
    );
  }

  Future<void> updateStatus(OrderStatus newStatus) async {
    if (isClosed) return;
    if (state is! OrderDetailsLoaded) return;

    final current = (state as OrderDetailsLoaded).order;
    emit(OrderDetailsUpdating(current));

    final result = await updateOrderStatusUseCase(
      orderId: current.id,
      newStatus: newStatus,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(OrderDetailsStatusError(failure.message, current));
        emit(OrderDetailsLoaded(current));
      },
      (_) {
        final updated = OrderDetailsEntity(
          id: current.id,
          platformOrderId: current.platformOrderId,
          orderCode: current.orderCode,
          status: newStatus,
          dateTime: current.dateTime,
          orderType: current.orderType,
          itemCount: current.itemCount,
          subtotal: current.subtotal,
          discount: current.discount,
          shippingCost: current.shippingCost,
          commission: current.commission,
          totalAmount: current.totalAmount,
          notes: current.notes,
          vendorName: current.vendorName,
          vendorPhone: current.vendorPhone,
          vendorAddress: current.vendorAddress,
          vendorImage: current.vendorImage,
          branchName: current.branchName,
          branchPhone: current.branchPhone,
          branchAddress: current.branchAddress,
          items: current.items,
        );
        emit(OrderDetailsStatusUpdated(updated));
        emit(OrderDetailsLoaded(updated));
      },
    );
  }
}
