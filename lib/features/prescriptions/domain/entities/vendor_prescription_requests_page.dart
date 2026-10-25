import 'package:equatable/equatable.dart';
import 'prescription_request_status.dart';
import 'vendor_prescription_request.dart';

class VendorPrescriptionRequestsPage extends Equatable {
  final List<VendorPrescriptionRequest> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final PrescriptionRequestStatus appliedFilter;

  const VendorPrescriptionRequestsPage({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.appliedFilter,
  });

  bool get hasReachedMax => currentPage >= lastPage;

  int get pendingCount =>
      data.where((e) => e.status == PrescriptionRequestStatus.pending).length;

  @override
  List<Object?> get props =>
      [data, currentPage, lastPage, perPage, total, appliedFilter];
}
