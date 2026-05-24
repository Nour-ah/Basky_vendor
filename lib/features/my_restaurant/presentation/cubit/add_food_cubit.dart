import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/add_product_params.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_variant_entity.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_variants_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import 'add_food_state.dart';

class AddFoodCubit extends Cubit<AddFoodState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final GetVariantsUseCase getVariantsUseCase;

  List<CategoryEntity> cachedCategories = const [];
  List<ProductVariantEntity> cachedVariants = const [];

  AddFoodCubit({
    required this.getCategoriesUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.getVariantsUseCase,
  }) : super(AddFoodInitial());

  Future<void> loadForm() async {
    if (isClosed) return;
    emit(AddFoodLoadingForm());

    final categoryResult = await getCategoriesUseCase();
    final variantResult = await getVariantsUseCase(NoParams());
    if (isClosed) return;

    categoryResult.fold(
      (failure) => emit(AddFoodError(failure.message)),
      (categories) {
        cachedCategories = categories;
        variantResult.fold(
          (failure) => emit(AddFoodError(failure.message)),
          (variants) {
            cachedVariants = variants;
            emit(AddFoodFormReady(categories: categories, variants: variants));
          },
        );
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
