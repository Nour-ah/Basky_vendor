import 'package:equatable/equatable.dart';
import '../../domain/entities/vendor_prescription_request.dart';
import '../models/prescription_list_filter.dart';

abstract class PrescriptionsListState extends Equatable {
  const PrescriptionsListState();

  @override
  List<Object?> get props => [];
}

class PrescriptionsListInitial extends PrescriptionsListState {}

class PrescriptionsListLoading extends PrescriptionsListState {
  final PrescriptionListFilter filter;
  const PrescriptionsListLoading({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class PrescriptionsListLoaded extends PrescriptionsListState {
  final List<VendorPrescriptionRequest> requests;
  final PrescriptionListFilter filter;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int total;
  final int? pendingCount;

  const PrescriptionsListLoaded({
    required this.requests,
    required this.filter,
    required this.currentPage,
    required this.hasReachedMax,
    this.isLoadingMore = false,
    required this.total,
    this.pendingCount,
  });

  PrescriptionsListLoaded copyWith({
    List<VendorPrescriptionRequest>? requests,
    PrescriptionListFilter? filter,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? total,
    int? pendingCount,
  }) {
    return PrescriptionsListLoaded(
      requests: requests ?? this.requests,
      filter: filter ?? this.filter,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      total: total ?? this.total,
      pendingCount: pendingCount ?? this.pendingCount,
    );
  }

  @override
  List<Object?> get props => [
        requests,
        filter,
        currentPage,
        hasReachedMax,
        isLoadingMore,
        total,
        pendingCount,
      ];
}

class PrescriptionsListEmpty extends PrescriptionsListState {
  final PrescriptionListFilter filter;
  final int? pendingCount;
  const PrescriptionsListEmpty({required this.filter, this.pendingCount});

  @override
  List<Object?> get props => [filter, pendingCount];
}

abstract class PrescriptionsListError extends PrescriptionsListState {
  final String message;
  final PrescriptionListFilter filter;
  const PrescriptionsListError(this.message, {required this.filter});

  @override
  List<Object?> get props => [message, filter];
}

class PrescriptionsListNetworkError extends PrescriptionsListError {
  const PrescriptionsListNetworkError(super.message, {required super.filter});
}

class PrescriptionsListUnauthorizedError extends PrescriptionsListError {
  const PrescriptionsListUnauthorizedError(super.message,
      {required super.filter});
}

class PrescriptionsListGenericError extends PrescriptionsListError {
  const PrescriptionsListGenericError(super.message, {required super.filter});
}
