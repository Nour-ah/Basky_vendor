import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_vendor_prescription_request_details_usecase.dart';
import 'prescription_details_state.dart';

class PrescriptionDetailsCubit extends Cubit<PrescriptionDetailsState> {
  final GetVendorPrescriptionRequestDetailsUseCase
      getVendorPrescriptionRequestDetailsUseCase;

  PrescriptionDetailsCubit({
    required this.getVendorPrescriptionRequestDetailsUseCase,
  }) : super(PrescriptionDetailsInitial());

  Future<void> fetchDetails(int requestId) async {
    if (isClosed) return;
    emit(PrescriptionDetailsLoading());

    final result = await getVendorPrescriptionRequestDetailsUseCase(requestId);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is UnauthorizedFailure) {
          emit(PrescriptionDetailsUnauthorized(failure.message));
        } else {
          emit(PrescriptionDetailsError(
            failure.message,
            isNetworkError: failure is NetworkFailure,
          ));
        }
      },
      (request) => emit(PrescriptionDetailsLoaded(request)),
    );
  }
}
