import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prescription_quote_item_input.dart';
import '../entities/prescription_request_status.dart';
import '../entities/vendor_prescription_request.dart';
import '../entities/vendor_prescription_requests_page.dart';

abstract class PrescriptionsRepository {
  Future<Either<Failure, VendorPrescriptionRequestsPage>>
      getVendorPrescriptionRequests({
    PrescriptionRequestStatus status = PrescriptionRequestStatus.all,
    int page = 1,
    int perPage = 15,
  });

  Future<Either<Failure, VendorPrescriptionRequest>>
      getVendorPrescriptionRequestDetails(int requestId);

  Future<Either<Failure, VendorPrescriptionRequest>>
      submitPrescriptionQuotation({
    required int requestId,
    required List<PrescriptionQuoteItemInput> items,
  });
}
