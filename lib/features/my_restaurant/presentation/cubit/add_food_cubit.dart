import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/add_product_params.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import 'add_food_state.dart';

class AddFoodCubit extends Cubit<AddFoodState> {
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;

  AddFoodCubit({
    required this.addProductUseCase,
    required this.updateProductUseCase,
  }) : super(AddFoodInitial());

  Future<void> submitForm(AddProductParams params) async {
    if (isClosed) return;
    emit(AddFoodSubmitting());

    final result = params.isEditMode && params.productId != null
        ? await updateProductUseCase(params.productId!, params)
        : await addProductUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(AddFoodValidationError(failure.errors));
        } else {
          emit(AddFoodError(failure.message));
        }
      },
      (_) => emit(AddFoodSuccess()),
    );
  }
}
