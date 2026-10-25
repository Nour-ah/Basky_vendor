enum PrescriptionRequestStatus {
  pending,
  quoted,
  converted,
  userRejected,
  cancelled,
  all;

  static PrescriptionRequestStatus fromString(String? status) {
    switch (status?.toLowerCase().trim()) {
      case 'pending':
        return PrescriptionRequestStatus.pending;
      case 'quoted':
        return PrescriptionRequestStatus.quoted;
      case 'converted':
        return PrescriptionRequestStatus.converted;
      case 'user_rejected':
        return PrescriptionRequestStatus.userRejected;
      case 'cancelled':
      case 'canceled':
        return PrescriptionRequestStatus.cancelled;
      default:
        return PrescriptionRequestStatus.all;
    }
  }

  String? toApiString() {
    switch (this) {
      case PrescriptionRequestStatus.pending:
        return 'pending';
      case PrescriptionRequestStatus.quoted:
        return 'quoted';
      case PrescriptionRequestStatus.converted:
        return 'converted';
      case PrescriptionRequestStatus.userRejected:
        return 'user_rejected';
      case PrescriptionRequestStatus.cancelled:
        return 'cancelled';
      case PrescriptionRequestStatus.all:
        return null;
    }
  }

  bool get isClosed =>
      this == PrescriptionRequestStatus.userRejected ||
      this == PrescriptionRequestStatus.cancelled;

  bool get canQuote => this == PrescriptionRequestStatus.pending;
}
