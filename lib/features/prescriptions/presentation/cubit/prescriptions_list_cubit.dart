import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/prescription_request_status.dart';
import '../../domain/entities/vendor_prescription_request.dart';
import '../../domain/usecases/get_vendor_prescription_requests_usecase.dart';
import '../models/prescription_list_filter.dart';
import 'prescriptions_list_state.dart';

class PrescriptionsListCubit extends Cubit<PrescriptionsListState> {
  final GetVendorPrescriptionRequestsUseCase getVendorPrescriptionRequestsUseCase;

  static const int _perPage = 15;

  int? _pendingCount;

  PrescriptionsListCubit({
    required this.getVendorPrescriptionRequestsUseCase,
  }) : super(PrescriptionsListInitial());

  Future<void> fetchRequests({
    PrescriptionListFilter filter = PrescriptionListFilter.all,
    bool isRefresh = false,
  }) async {
    if (isClosed) return;
    emit(PrescriptionsListLoading(filter: filter));

    await _refreshPendingCount();

    final apiStatus =
        filter.apiStatus ?? PrescriptionRequestStatus.all;

    final result = await getVendorPrescriptionRequestsUseCase(
      status: apiStatus,
      page: 1,
      perPage: _perPage,
    );
    if (isClosed) return;

    result.fold(
      (failure) => _emitFailure(failure, filter),
      (page) {
        final requests = _applyClientFilter(page.data, filter);
        if (requests.isEmpty) {
          emit(PrescriptionsListEmpty(
            filter: filter,
            pendingCount: _pendingCount,
          ));
        } else {
          emit(PrescriptionsListLoaded(
            requests: requests,
            filter: filter,
            currentPage: page.currentPage,
            hasReachedMax: page.hasReachedMax,
            total: page.total,
            pendingCount: _pendingCount,
          ));
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (isClosed) return;
    if (state is! PrescriptionsListLoaded) return;

    final current = state as PrescriptionsListLoaded;
    if (current.hasReachedMax || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final apiStatus =
        current.filter.apiStatus ?? PrescriptionRequestStatus.all;
    final nextPage = current.currentPage + 1;
    final result = await getVendorPrescriptionRequestsUseCase(
      status: apiStatus,
      page: nextPage,
      perPage: _perPage,
    );
    if (isClosed) return;

    result.fold(
      (_) {
        if (!isClosed) emit(current.copyWith(isLoadingMore: false));
      },
      (page) {
        final filtered = _applyClientFilter(page.data, current.filter);
        emit(current.copyWith(
          requests: List.of(current.requests)..addAll(filtered),
          currentPage: nextPage,
          hasReachedMax: page.hasReachedMax,
          isLoadingMore: false,
          total: page.total,
          pendingCount: _pendingCount,
        ));
      },
    );
  }

  Future<void> _refreshPendingCount() async {
    final result = await getVendorPrescriptionRequestsUseCase(
      status: PrescriptionRequestStatus.pending,
      page: 1,
      perPage: 1,
    );
    result.fold(
      (_) {},
      (page) => _pendingCount = page.total,
    );
  }

  List<VendorPrescriptionRequest> _applyClientFilter(
    List<VendorPrescriptionRequest> data,
    PrescriptionListFilter filter,
  ) {
    if (filter == PrescriptionListFilter.closed) {
      return data.where((e) => filter.matches(e.status)).toList();
    }
    return data;
  }

  void _emitFailure(Failure failure, PrescriptionListFilter filter) {
    if (failure is NetworkFailure) {
      emit(PrescriptionsListNetworkError(failure.message, filter: filter));
    } else if (failure is UnauthorizedFailure) {
      emit(PrescriptionsListUnauthorizedError(failure.message, filter: filter));
    } else {
      emit(PrescriptionsListGenericError(failure.message, filter: filter));
    }
  }
}
