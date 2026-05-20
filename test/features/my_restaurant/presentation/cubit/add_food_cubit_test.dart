import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/add_product_params.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/add_product_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/update_product_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/presentation/cubit/add_food_cubit.dart';
import 'package:spider_restaurant/features/my_restaurant/presentation/cubit/add_food_state.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_status.dart';

class MockAddProductUseCase extends AddProductUseCase {
  MockAddProductUseCase(super.repository);
  bool shouldReturnError = false;

  @override
  Future<Either<Failure, void>> call(AddProductParams params) async {
    if (shouldReturnError) {
      return const Left(ValidationFailure('Error', errors: {'price': ['must be number']}));
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
    mockAddProductUseCase = MockAddProductUseCase(null as dynamic); // using null repo as we override call
    mockUpdateProductUseCase = MockUpdateProductUseCase(null as dynamic);
    
    cubit = AddFoodCubit(
      addProductUseCase: mockAddProductUseCase,
      updateProductUseCase: mockUpdateProductUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tParams = AddProductParams(
    name: 'Pizza',
    description: 'Cheese',
    price: 15,
    discountPercentage: 0,
    categoryId: 2,
    maxOrderQuantity: 10,
    status: ProductStatus.active,
  );

  blocTest<AddFoodCubit, AddFoodState>(
    'emits [AddFoodSubmitting, AddFoodSuccess] on successful submission',
    build: () => cubit,
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
