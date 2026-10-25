import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basky_vendor/core/error/failures.dart';
import 'package:basky_vendor/core/usecases/usecase.dart';
import 'package:basky_vendor/features/variants/domain/entities/variant_entity.dart';
import 'package:basky_vendor/features/variants/domain/usecases/add_variant_usecase.dart';
import 'package:basky_vendor/features/variants/domain/usecases/delete_variant_usecase.dart';
import 'package:basky_vendor/features/variants/domain/usecases/get_variants_usecase.dart';
import 'package:basky_vendor/features/variants/domain/usecases/update_variant_usecase.dart';
import 'package:basky_vendor/features/variants/presentation/cubit/variants_cubit.dart';
import 'package:basky_vendor/features/variants/presentation/cubit/variants_state.dart';

class MockGetVariantsUseCase extends Mock implements GetVariantsUseCase {}
class MockAddVariantUseCase extends Mock implements AddVariantUseCase {}
class MockUpdateVariantUseCase extends Mock implements UpdateVariantUseCase {}
class MockDeleteVariantUseCase extends Mock implements DeleteVariantUseCase {}

class FakeNoParams extends Fake implements NoParams {}
class FakeAddVariantParams extends Fake implements AddVariantParams {}
class FakeUpdateVariantParams extends Fake implements UpdateVariantParams {}


void main() {
  late VariantsCubit cubit;
  late MockGetVariantsUseCase mockGetVariantsUseCase;
  late MockAddVariantUseCase mockAddVariantUseCase;
  late MockUpdateVariantUseCase mockUpdateVariantUseCase;
  late MockDeleteVariantUseCase mockDeleteVariantUseCase;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
    registerFallbackValue(FakeAddVariantParams());
    registerFallbackValue(FakeUpdateVariantParams());
  });

  setUp(() {
    mockGetVariantsUseCase = MockGetVariantsUseCase();
    mockAddVariantUseCase = MockAddVariantUseCase();
    mockUpdateVariantUseCase = MockUpdateVariantUseCase();
    mockDeleteVariantUseCase = MockDeleteVariantUseCase();

    cubit = VariantsCubit(
      getVariantsUseCase: mockGetVariantsUseCase,
      addVariantUseCase: mockAddVariantUseCase,
      updateVariantUseCase: mockUpdateVariantUseCase,
      deleteVariantUseCase: mockDeleteVariantUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final tVariant = VariantEntity(id: 1, name: 'Size', options: const []);

  group('fetchVariants', () {
    blocTest<VariantsCubit, VariantsState>(
      'should emit [VariantsLoading, VariantsLoaded] when successful',
      build: () {
        when(() => mockGetVariantsUseCase(any()))
            .thenAnswer((_) async => Right([tVariant]));
        return cubit;
      },
      act: (cubit) => cubit.fetchVariants(),
      expect: () => [
        isA<VariantsLoading>(),
        isA<VariantsLoaded>(),
      ],
      verify: (_) {
        verify(() => mockGetVariantsUseCase(any())).called(1);
      },
    );

    blocTest<VariantsCubit, VariantsState>(
      'should emit [VariantsLoading, VariantsError] when unsuccessful',
      build: () {
        when(() => mockGetVariantsUseCase(any()))
            .thenAnswer((_) async => Left(ServerFailure('Server Error')));
        return cubit;
      },
      act: (cubit) => cubit.fetchVariants(),
      expect: () => [
        isA<VariantsLoading>(),
        isA<VariantsError>(),
      ],
    );
  });

  group('addVariant', () {
    blocTest<VariantsCubit, VariantsState>(
      'should emit [VariantsSubmitting, VariantsActionSuccess] and fetch variants',
      build: () {
        when(() => mockAddVariantUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetVariantsUseCase(any()))
            .thenAnswer((_) async => Right([tVariant]));
        return cubit;
      },
      act: (cubit) => cubit.addVariant('Color', ['Red', 'Blue']),
      expect: () => [
        isA<VariantsSubmitting>(),
        isA<VariantsActionSuccess>(),
        isA<VariantsLoading>(),
        isA<VariantsLoaded>(),
      ],
      verify: (_) {
        verify(() => mockAddVariantUseCase(const AddVariantParams(name: 'Color', options: ['Red', 'Blue']))).called(1);
      },
    );
  });
}
