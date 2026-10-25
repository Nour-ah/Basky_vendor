import '../../domain/entities/prescription_request_status.dart';

enum PrescriptionListFilter {
  all,
  pending,
  quoted,
  converted,
  closed;

  PrescriptionRequestStatus? get apiStatus {
    switch (this) {
      case PrescriptionListFilter.all:
      case PrescriptionListFilter.closed:
        return null;
      case PrescriptionListFilter.pending:
        return PrescriptionRequestStatus.pending;
      case PrescriptionListFilter.quoted:
        return PrescriptionRequestStatus.quoted;
      case PrescriptionListFilter.converted:
        return PrescriptionRequestStatus.converted;
    }
  }

  bool matches(PrescriptionRequestStatus status) {
    switch (this) {
      case PrescriptionListFilter.all:
        return true;
      case PrescriptionListFilter.pending:
        return status == PrescriptionRequestStatus.pending;
      case PrescriptionListFilter.quoted:
        return status == PrescriptionRequestStatus.quoted;
      case PrescriptionListFilter.converted:
        return status == PrescriptionRequestStatus.converted;
      case PrescriptionListFilter.closed:
        return status.isClosed;
    }
  }
}
