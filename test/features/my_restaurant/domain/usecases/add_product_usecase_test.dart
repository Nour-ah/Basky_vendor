import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/add_product_params.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_status.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/repositories/restaurant_repository.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/add_product_usecase.dart';

class MockRestaurantRepository implements RestaurantRepository {
  bool shouldFail = false;
  
  @override
  Future<Either<Failure, void>> addProduct(AddProductParams params) async {
    if (shouldFail) {
      return const Left(ValidationFailure('Validation Error', errors: {'name': ['required']}));
    }
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late AddProductUseCase usecase;
  late MockRestaurantRepository mockRepo;

  setUp(() {
    mockRepo = MockRestaurantRepository();
    usecase = AddProductUseCase(mockRepo);
  });

  final tParams = AddProductParams(
    name: 'Burger',
    description: 'Tasty',
    price: 10,
    discountPercentage: 0,
    categoryId: 1,
    maxOrderQuantity: 5,
    status: ProductStatus.active,
  );

  test('should return Right(void) when adding product is successful', () async {
    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(null));
  });

  test('should return Left(ValidationFailure) when adding product fails validation', () async {
    // arrange
    mockRepo.shouldFail = true;

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, isA<Left<Failure, void>>());
    result.fold(
      (l) {
        expect(l, isA<ValidationFailure>());
        expect((l as ValidationFailure).errors.containsKey('name'), true);
      },
      (r) => fail('Should not succeed'),
    );
  });
}
