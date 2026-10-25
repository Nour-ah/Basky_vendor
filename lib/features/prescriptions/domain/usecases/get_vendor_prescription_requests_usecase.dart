import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prescription_request_status.dart';
import '../entities/vendor_prescription_requests_page.dart';
import '../repositories/prescriptions_repository.dart';

class GetVendorPrescriptionRequestsUseCase {
  final PrescriptionsRepository repository;

  GetVendorPrescriptionRequestsUseCase(this.repository);

  Future<Either<Failure, VendorPrescriptionRequestsPage>> call({
    PrescriptionRequestStatus status = PrescriptionRequestStatus.all,
    int page = 1,
    int perPage = 15,
  }) {
    return repository.getVendorPrescriptionRequests(
      status: status,
      page: page,
      perPage: perPage,
    );
  }
}
