import 'package:equatable/equatable.dart';
import '../../domain/entities/vendor_prescription_request.dart';

abstract class PrescriptionQuotationState extends Equatable {
  const PrescriptionQuotationState();

  @override
  List<Object?> get props => [];
}

class PrescriptionQuotationInitial extends PrescriptionQuotationState {}

class PrescriptionQuotationSubmitting extends PrescriptionQuotationState {}

class PrescriptionQuotationSuccess extends PrescriptionQuotationState {
  final VendorPrescriptionRequest request;
  const PrescriptionQuotationSuccess(this.request);

  @override
  List<Object?> get props => [request];
}

class PrescriptionQuotationFailure extends PrescriptionQuotationState {
  final String message;
  const PrescriptionQuotationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PrescriptionQuotationValidationError extends PrescriptionQuotationState {
  final String message;
  const PrescriptionQuotationValidationError(this.message);

  @override
  List<Object?> get props => [message];
}
