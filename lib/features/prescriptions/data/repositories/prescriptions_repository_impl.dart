import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/prescription_quote_item_input.dart';
import '../../domain/entities/prescription_request_status.dart';
import '../../domain/entities/vendor_prescription_request.dart';
import '../../domain/entities/vendor_prescription_requests_page.dart';
import '../../domain/repositories/prescriptions_repository.dart';
import '../datasources/prescriptions_remote_datasource.dart';

class PrescriptionsRepositoryImpl implements PrescriptionsRepository {
  final PrescriptionsRemoteDataSource remoteDataSource;

  PrescriptionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, VendorPrescriptionRequestsPage>>
      getVendorPrescriptionRequests({
    PrescriptionRequestStatus status = PrescriptionRequestStatus.all,
    int page = 1,
    int perPage = 15,
  }) {
    return _execute(
      () => remoteDataSource.getVendorPrescriptionRequests(
        status: status,
        page: page,
        perPage: perPage,
      ),
    );
  }

  @override
  Future<Either<Failure, VendorPrescriptionRequest>>
      getVendorPrescriptionRequestDetails(int requestId) {
    return _execute(
      () => remoteDataSource.getVendorPrescriptionRequestDetails(requestId),
    );
  }

  @override
  Future<Either<Failure, VendorPrescriptionRequest>>
      submitPrescriptionQuotation({
    required int requestId,
    required List<PrescriptionQuoteItemInput> items,
  }) {
    return _execute(
      () => remoteDataSource.submitPrescriptionQuotation(
        requestId: requestId,
        items: items,
      ),
    );
  }

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
