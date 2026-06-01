import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/features/home/presentation/cubit/toggle_status_cubit.dart';
import 'package:spider_restaurant/features/home/presentation/cubit/toggle_status_state.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/repositories/restaurant_repository.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/toggle_restaurant_status_usecase.dart';

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
  late ToggleStatusCubit cubit;
  late MockRestaurantRepository mockRepo;
  late ToggleRestaurantStatusUseCase toggleUseCase;

  setUp(() {
    mockRepo = MockRestaurantRepository();
    toggleUseCase = ToggleRestaurantStatusUseCase(mockRepo);
    cubit = ToggleStatusCubit(toggleRestaurantStatusUseCase: toggleUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be ToggleStatusInitial', () {
    expect(cubit.state, equals(ToggleStatusInitial()));
  });

  blocTest<ToggleStatusCubit, ToggleStatusState>(
    'should emit [ToggleStatusSuccess] with new status when api call is successful',
    build: () {
      mockRepo.returnStatus = true;
      return cubit;
    },
    act: (c) => c.toggleStatus(false), // current is closed, new is open (true)
    expect: () => [
      const ToggleStatusSuccess(true), // optimistic UI update
    ],
  );

  blocTest<ToggleStatusCubit, ToggleStatusState>(
    'should emit [ToggleStatusSuccess(true), ToggleStatusError, ToggleStatusSuccess(false)] when api call fails',
    build: () {
      mockRepo.shouldFail = true;
      return cubit;
    },
    act: (c) => c.toggleStatus(false), // current is closed, new is open (true)
    expect: () => [
      const ToggleStatusSuccess(true), // optimistic UI update
      const ToggleStatusError('Server Error'), // error emitted
      const ToggleStatusSuccess(false), // revert back to original status
    ],
  );
}
