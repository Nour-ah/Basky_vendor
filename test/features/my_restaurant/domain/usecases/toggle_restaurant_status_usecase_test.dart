import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:basky_vendor/core/error/failures.dart';
import 'package:basky_vendor/features/my_restaurant/domain/repositories/restaurant_repository.dart';
import 'package:basky_vendor/features/my_restaurant/domain/usecases/toggle_restaurant_status_usecase.dart';

class MockRestaurantRepository implements RestaurantRepository {
  bool shouldFail = false;
  bool returnStatus = true;

  @override
  Future<Either<Failure, bool>> toggleStatus() async {
    if (shouldFail) {
      return const Left(ServerFailure('Server Error'));
    }
    return Right(returnStatus);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late ToggleRestaurantStatusUseCase usecase;
  late MockRestaurantRepository mockRepo;

  setUp(() {
    mockRepo = MockRestaurantRepository();
    usecase = ToggleRestaurantStatusUseCase(mockRepo);
  });

  test('should return Right(true) when toggle status is successful and branch is open', () async {
    // arrange
    mockRepo.returnStatus = true;

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(true));
  });

  test('should return Right(false) when toggle status is successful and branch is closed', () async {
    // arrange
    mockRepo.returnStatus = false;

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(false));
  });

  test('should return Left(ServerFailure) when repository fails', () async {
    // arrange
    mockRepo.shouldFail = true;

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(ServerFailure('Server Error')));
  });
}
