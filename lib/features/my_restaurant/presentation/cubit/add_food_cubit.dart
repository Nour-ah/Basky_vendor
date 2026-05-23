import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/add_product_params.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import 'add_food_state.dart';

class AddFoodCubit extends Cubit<AddFoodState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;

  List<CategoryEntity> cachedCategories = const [];

  AddFoodCubit({
    required this.getCategoriesUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
  }) : super(AddFoodInitial());

  Future<void> loadForm() async {
    if (isClosed) return;
    emit(AddFoodLoadingForm());

    final result = await getCategoriesUseCase();
    if (isClosed) return;

    result.fold(
      (failure) => emit(AddFoodError(failure.message)),
      (categories) {
        cachedCategories = categories;
        emit(AddFoodFormReady(categories: categories));
      },
    );
  }

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
