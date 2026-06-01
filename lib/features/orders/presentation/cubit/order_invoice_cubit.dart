import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_order_invoice_usecase.dart';
import 'order_invoice_state.dart';

class OrderInvoiceCubit extends Cubit<OrderInvoiceState> {
  final GetOrderInvoiceUseCase getOrderInvoiceUseCase;

  OrderInvoiceCubit({required this.getOrderInvoiceUseCase})
      : super(OrderInvoiceInitial());

  Future<void> fetchInvoice(int orderId) async {
    if (isClosed) return;
    emit(OrderInvoiceLoading());

    final result = await getOrderInvoiceUseCase(orderId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(OrderInvoiceError(
        failure.message,
        isNetworkError: failure is NetworkFailure,
      )),
      (invoice) => emit(OrderInvoiceLoaded(invoice)),
    );
  }
}
