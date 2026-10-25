import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basky_vendor/core/error/failures.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/vendor_branch_entity.dart';
import 'package:basky_vendor/features/my_restaurant/domain/repositories/restaurant_repository.dart';
import 'package:basky_vendor/features/my_restaurant/domain/usecases/get_vendor_branches_usecase.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  late GetVendorBranchesUseCase usecase;
  late MockRestaurantRepository mockRepository;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    usecase = GetVendorBranchesUseCase(mockRepository);
  });

  final tBranches = [
    const VendorBranchEntity(
      id: 1,
      name: 'Branch 1',
      address: 'Address 1',
      isOpen: true,
      rating: 4.5,
      phone: '1234567890',
      latitude: '30.0',
      longitude: '31.0',
    ),
  ];

  test('should get branches from the repository', () async {
    // arrange
    when(() => mockRepository.getBranches())
        .thenAnswer((_) async => Right(tBranches));
    // act
    final result = await usecase();
    // assert
    expect(result, Right(tBranches));
    verify(() => mockRepository.getBranches());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(() => mockRepository.getBranches())
        .thenAnswer((_) async => const Left(ServerFailure('Error')));
    // act
    final result = await usecase();
    // assert
    expect(result, const Left(ServerFailure('Error')));
    verify(() => mockRepository.getBranches());
    verifyNoMoreInteractions(mockRepository);
  });
}
