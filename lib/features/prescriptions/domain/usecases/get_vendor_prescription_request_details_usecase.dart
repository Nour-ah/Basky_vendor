import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/vendor_prescription_request.dart';
import '../repositories/prescriptions_repository.dart';

class GetVendorPrescriptionRequestDetailsUseCase {
  final PrescriptionsRepository repository;

  GetVendorPrescriptionRequestDetailsUseCase(this.repository);

  Future<Either<Failure, VendorPrescriptionRequest>> call(int requestId) {
    return repository.getVendorPrescriptionRequestDetails(requestId);
  }
}
