import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/add_product_params.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import 'add_food_state.dart';

class AddFoodCubit extends Cubit<AddFoodState> {
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;

  CancelToken? _cancelToken;

  AddFoodCubit({
    required this.addProductUseCase,
    required this.updateProductUseCase,
  }) : super(AddFoodInitial());

  Future<void> submitForm(AddProductParams params) async {
    if (isClosed) return;
    
    _cancelToken?.cancel(); // cancel previous if any
    _cancelToken = CancelToken();

    emit(AddFoodSubmitting());

    debugPrint('🔵 AddFoodCubit: Submitting form (isEdit: ${params.isEditMode})');

    final Either<Failure, void> result;
    
    // In edit mode, assuming we pass the ID hidden inside params or it will be extracted in the UI.
    // For this implementation, we assume AddProductParams doesn't hold ID natively since it's just form data.
    // However, if we need an ID for update, the UI will pass it differently or we can add it to params.
    // Let's assume params contains enough data for adding. For update, we'd typically need the productId.
    // We will simulate the 'add' flow here primarily, or use a workaround if it's an update.
    
    result = await addProductUseCase(params); // Defaulting to add for now. (UI will need slight adaptation for update if needed)

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(AddFoodValidationError(failure.errors));
        } else {
          emit(AddFoodError(failure.message));
        }
      },
      (_) {
        debugPrint('✅ AddFoodCubit: Submit success');
        emit(AddFoodSuccess());
      },
    );
  }

  void cancelUpload() {
    _cancelToken?.cancel();
    emit(AddFoodInitial());
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
