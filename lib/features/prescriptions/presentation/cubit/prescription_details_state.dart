import 'package:equatable/equatable.dart';
import '../../domain/entities/vendor_prescription_request.dart';

abstract class PrescriptionDetailsState extends Equatable {
  const PrescriptionDetailsState();

  @override
  List<Object?> get props => [];
}

class PrescriptionDetailsInitial extends PrescriptionDetailsState {}

class PrescriptionDetailsLoading extends PrescriptionDetailsState {}

class PrescriptionDetailsLoaded extends PrescriptionDetailsState {
  final VendorPrescriptionRequest request;
  const PrescriptionDetailsLoaded(this.request);

  @override
  List<Object?> get props => [request];
}

class PrescriptionDetailsError extends PrescriptionDetailsState {
  final String message;
  final bool isNetworkError;
  const PrescriptionDetailsError(
    this.message, {
    this.isNetworkError = false,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}

class PrescriptionDetailsUnauthorized extends PrescriptionDetailsState {
  final String message;
  const PrescriptionDetailsUnauthorized(this.message);

  @override
  List<Object?> get props => [message];
}
