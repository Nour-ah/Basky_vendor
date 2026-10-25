import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prescription_quote_item_input.dart';
import '../../domain/usecases/submit_prescription_quotation_usecase.dart';
import 'prescription_quotation_state.dart';

class PrescriptionQuotationCubit extends Cubit<PrescriptionQuotationState> {
  final SubmitPrescriptionQuotationUseCase submitPrescriptionQuotationUseCase;

  bool _isSubmitting = false;

  PrescriptionQuotationCubit({
    required this.submitPrescriptionQuotationUseCase,
  }) : super(PrescriptionQuotationInitial());

  Future<void> submit({
    required int requestId,
    required List<PrescriptionQuoteItemInput> items,
  }) async {
    if (isClosed || _isSubmitting) return;

    final validationError = _validate(items);
    if (validationError != null) {
      emit(PrescriptionQuotationValidationError(validationError));
      return;
    }

    _isSubmitting = true;
    emit(PrescriptionQuotationSubmitting());

    final result = await submitPrescriptionQuotationUseCase(
      requestId: requestId,
      items: items,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        _isSubmitting = false;
        emit(PrescriptionQuotationFailure(failure.message));
      },
      (request) {
        _isSubmitting = false;
        emit(PrescriptionQuotationSuccess(request));
      },
    );
  }

  void reset() {
    if (isClosed) return;
    _isSubmitting = false;
    emit(PrescriptionQuotationInitial());
  }

  String? _validate(List<PrescriptionQuoteItemInput> items) {
    if (items.isEmpty) {
      return 'prescriptionAtLeastOneMedicine';
    }
    for (final item in items) {
      if (item.medicineName.trim().isEmpty) {
        return 'prescriptionMedicineNameRequired';
      }
      if (item.quantity <= 0) {
        return 'prescriptionQuantityInvalid';
      }
      if (item.isAvailable) {
        if (item.price == null) {
          return 'prescriptionPriceRequired';
        }
        if (item.price! < 0) {
          return 'prescriptionPriceInvalid';
        }
      }
    }
    return null;
  }
}
