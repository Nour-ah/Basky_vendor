import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/add_product_params.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/category_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_details_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_summary_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/repositories/restaurant_repository.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/add_product_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/get_categories_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/update_product_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/presentation/cubit/add_food_cubit.dart';
import 'package:spider_restaurant/features/my_restaurant/presentation/cubit/add_food_state.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_status.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_variant_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/vendor_branch_entity.dart';

import 'package:spider_restaurant/features/my_restaurant/domain/usecases/get_variants_usecase.dart';

class FakeRestaurantRepository implements RestaurantRepository {
  @override
  Future<Either<Failure, VendorBranchEntity?>> getPrimaryBranch() async =>
      const Right(null);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async =>
      const Right([CategoryEntity(id: 1, name: 'Burgers')]);

  @override
  Future<Either<Failure, List<ProductVariantEntity>>> getVariants() async =>
      const Right([ProductVariantEntity(id: 1, name: 'Size', options: [])]);

  @override
  Future<Either<Failure, List<ProductSummaryEntity>>> getProducts({
    int? categoryId,
    String? searchQuery,
    int page = 1,
    int limit = 15,
  }) async =>
      const Right([]);

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(int productId) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> addProduct(AddProductParams params) async => const Right(null);

  @override
  Future<Either<Failure, void>> updateProduct(int productId, AddProductParams params) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> deleteProduct(int productId) async => const Right(null);

  @override
  Future<Either<Failure, void>> toggleProductActive(int productId) async =>
      const Right(null);

  @override
  Future<Either<Failure, bool>> toggleStatus() async => const Right(true);
}

class MockAddProductUseCase extends AddProductUseCase {
  MockAddProductUseCase(super.repository);
  bool shouldReturnError = false;

  @override
  Future<Either<Failure, void>> call(AddProductParams params) async {
    if (shouldReturnError) {
      return const Left(
        ValidationFailure('Error', errors: {'price': ['must be number']}),
      );
    }
    return const Right(null);
  }
}

class MockUpdateProductUseCase extends UpdateProductUseCase {
  MockUpdateProductUseCase(super.repository);
}

void main() {
  late AddFoodCubit cubit;
  late MockAddProductUseCase mockAddProductUseCase;
  late MockUpdateProductUseCase mockUpdateProductUseCase;

  setUp(() {
    final fakeRepo = FakeRestaurantRepository();
    mockAddProductUseCase = MockAddProductUseCase(fakeRepo);
    mockUpdateProductUseCase = MockUpdateProductUseCase(fakeRepo);

    cubit = AddFoodCubit(
      getCategoriesUseCase: GetCategoriesUseCase(fakeRepo),
      addProductUseCase: mockAddProductUseCase,
      updateProductUseCase: mockUpdateProductUseCase,
      getVariantsUseCase: GetVariantsUseCase(fakeRepo),
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tParams = AddProductParams(
    nameEn: 'Pizza',
    nameAr: 'بيتزا',
    descriptionEn: 'Cheese',
    descriptionAr: 'جبنة',
    price: 15,
    discountPercentage: 0,
    categoryId: 2,
    status: ProductStatus.active,
  );

  blocTest<AddFoodCubit, AddFoodState>(
    'emits [AddFoodLoadingForm, AddFoodFormReady] when form loads',
    build: () => cubit,
    act: (cubit) => cubit.loadForm(),
    expect: () => [
      isA<AddFoodLoadingForm>(),
      isA<AddFoodFormReady>()
          .having((s) => s.categories.length, 'categories', 1)
          .having((s) => s.variants.length, 'variants', 1),
    ],
  );

  blocTest<AddFoodCubit, AddFoodState>(
    'emits [AddFoodSubmitting, AddFoodSuccess] on successful submission',
    build: () => cubit,
    seed: () => const AddFoodFormReady(
      categories: [CategoryEntity(id: 1, name: 'Burgers')],
      variants: [],
    ),
    act: (cubit) => cubit.submitForm(tParams),
    expect: () => [
      isA<AddFoodSubmitting>(),
      isA<AddFoodSuccess>(),
    ],
  );

  blocTest<AddFoodCubit, AddFoodState>(
    'emits [AddFoodSubmitting, AddFoodValidationError] on validation failure',
    build: () {
      mockAddProductUseCase.shouldReturnError = true;
      return cubit;
    },
    seed: () => const AddFoodFormReady(
      categories: [CategoryEntity(id: 1, name: 'Burgers')],
      variants: [],
    ),
    act: (cubit) => cubit.submitForm(tParams),
    expect: () => [
      isA<AddFoodSubmitting>(),
      isA<AddFoodValidationError>().having(
        (s) => s.validationErrors.containsKey('price'),
        'has price error',
        true,
      ),
    ],
  );
}
