import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basky_vendor/core/error/failures.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/vendor_branch_entity.dart';
import 'package:basky_vendor/features/my_restaurant/domain/usecases/delete_branch_usecase.dart';
import 'package:basky_vendor/features/my_restaurant/domain/usecases/get_vendor_branches_usecase.dart';
import 'package:basky_vendor/features/my_restaurant/presentation/cubit/branches_cubit.dart';
import 'package:basky_vendor/features/my_restaurant/presentation/cubit/branches_state.dart';

class MockGetVendorBranchesUseCase extends Mock
    implements GetVendorBranchesUseCase {}

class MockDeleteBranchUseCase extends Mock implements DeleteBranchUseCase {}

void main() {
  late BranchesCubit cubit;
  late MockGetVendorBranchesUseCase mockUseCase;
  late MockDeleteBranchUseCase mockDeleteUseCase;

  setUp(() {
    mockUseCase = MockGetVendorBranchesUseCase();
    mockDeleteUseCase = MockDeleteBranchUseCase();
    cubit = BranchesCubit(
      getVendorBranchesUseCase: mockUseCase,
      deleteBranchUseCase: mockDeleteUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tBranches = [
    const VendorBranchEntity(
      id: 1,
      name: 'Branch 1',
      address: 'Address 1',
      isOpen: true,
      rating: 4.5,
    ),
  ];

  test('initial state should be BranchesInitial', () {
    expect(cubit.state, equals(BranchesInitial()));
  });

  blocTest<BranchesCubit, BranchesState>(
    'emits [BranchesLoading, BranchesLoaded] when fetching branches is successful',
    build: () {
      when(() => mockUseCase()).thenAnswer((_) async => Right(tBranches));
      return cubit;
    },
    act: (cubit) => cubit.fetchBranches(),
    expect: () => [
      BranchesLoading(),
      BranchesLoaded(branches: tBranches),
    ],
    verify: (_) {
      verify(() => mockUseCase()).called(1);
    },
  );

  blocTest<BranchesCubit, BranchesState>(
    'emits [BranchesLoading, BranchesEmpty] when branches list is empty',
    build: () {
      when(() => mockUseCase()).thenAnswer((_) async => const Right([]));
      return cubit;
    },
    act: (cubit) => cubit.fetchBranches(),
    expect: () => [
      BranchesLoading(),
      BranchesEmpty(),
    ],
  );

  blocTest<BranchesCubit, BranchesState>(
    'emits [BranchesLoading, BranchesError] when fetching fails',
    build: () {
      when(() => mockUseCase())
          .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
      return cubit;
    },
    act: (cubit) => cubit.fetchBranches(),
    expect: () => [
      BranchesLoading(),
      const BranchesError(message: 'Server Error'),
    ],
  );
}
