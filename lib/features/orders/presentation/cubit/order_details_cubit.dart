import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_details_entity.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/usecases/get_order_details_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderDetailsUseCase getOrderDetailsUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  OrderDetailsCubit({
    required this.getOrderDetailsUseCase,
    required this.updateOrderStatusUseCase,
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
