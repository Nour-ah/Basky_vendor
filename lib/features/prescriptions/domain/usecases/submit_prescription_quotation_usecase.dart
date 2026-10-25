import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prescription_quote_item_input.dart';
import '../entities/vendor_prescription_request.dart';
import '../repositories/prescriptions_repository.dart';

class SubmitPrescriptionQuotationUseCase {
  final PrescriptionsRepository repository;

  SubmitPrescriptionQuotationUseCase(this.repository);

  Future<Either<Failure, VendorPrescriptionRequest>> call({
    required int requestId,
    required List<PrescriptionQuoteItemInput> items,
  }) {
    return repository.submitPrescriptionQuotation(
      requestId: requestId,
      items: items,
    );
  }
}
