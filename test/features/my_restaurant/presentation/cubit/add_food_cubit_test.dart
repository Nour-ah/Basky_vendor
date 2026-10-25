import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basky_vendor/core/error/failures.dart';
import 'package:basky_vendor/core/usecases/usecase.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/add_product_params.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/category_entity.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/product_status.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/product_type.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/product_variant_entity.dart';
import 'package:basky_vendor/features/my_restaurant/domain/usecases/add_product_usecase.dart';
import 'package:basky_vendor/features/my_restaurant/domain/usecases/get_categories_usecase.dart';
import 'package:basky_vendor/features/my_restaurant/domain/usecases/get_variants_usecase.dart';
import 'package:basky_vendor/features/my_restaurant/domain/usecases/update_product_usecase.dart';
import 'package:basky_vendor/features/my_restaurant/presentation/cubit/add_food_cubit.dart';
import 'package:basky_vendor/features/my_restaurant/presentation/cubit/add_food_state.dart';

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}
class MockAddProductUseCase extends Mock implements AddProductUseCase {}
class MockUpdateProductUseCase extends Mock implements UpdateProductUseCase {}
class MockGetVariantsUseCase extends Mock implements GetVariantsUseCase {}

class FakeAddProductParams extends Fake implements AddProductParams {}
class FakeNoParams extends Fake implements NoParams {}

void main() {
  late AddFoodCubit cubit;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockAddProductUseCase mockAddProductUseCase;
  late MockUpdateProductUseCase mockUpdateProductUseCase;
  late MockGetVariantsUseCase mockGetVariantsUseCase;

  setUpAll(() {
    registerFallbackValue(FakeAddProductParams());
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockAddProductUseCase = MockAddProductUseCase();
    mockUpdateProductUseCase = MockUpdateProductUseCase();
    mockGetVariantsUseCase = MockGetVariantsUseCase();

    cubit = AddFoodCubit(
      getCategoriesUseCase: mockGetCategoriesUseCase,
      addProductUseCase: mockAddProductUseCase,
      updateProductUseCase: mockUpdateProductUseCase,
      getVariantsUseCase: mockGetVariantsUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  final List<CategoryEntity> tCategories = [
    const CategoryEntity(id: 1, name: 'Burger'),
  ];
  final tVariants = <ProductVariantEntity>[];

  group('loadForm', () {
    blocTest<AddFoodCubit, AddFoodState>(
      'emits [AddFoodLoadingForm, AddFoodFormReady] on success',
      build: () {
        when(() => mockGetCategoriesUseCase())
            .thenAnswer((_) async => Right(tCategories));
        when(() => mockGetVariantsUseCase(any()))
            .thenAnswer((_) async => Right(tVariants));
        return cubit;
      },
      act: (cubit) => cubit.loadForm(),
      expect: () => [
        AddFoodLoadingForm(),
        AddFoodFormReady(categories: tCategories, variants: tVariants),
      ],
      verify: (_) {
        verify(() => mockGetCategoriesUseCase()).called(1);
        verify(() => mockGetVariantsUseCase(any())).called(1);
      },
    );

    blocTest<AddFoodCubit, AddFoodState>(
      'emits [AddFoodLoadingForm, AddFoodError] on failure',
      build: () {
        when(() => mockGetCategoriesUseCase())
            .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        when(() => mockGetVariantsUseCase(any()))
            .thenAnswer((_) async => Right(tVariants));
        return cubit;
      },
      act: (cubit) => cubit.loadForm(),
      expect: () => [
        AddFoodLoadingForm(),
        const AddFoodError('Server Error'),
      ],
    );
  });

  group('submitForm', () {
    final tParamsAdd = AddProductParams(
      nameEn: 'Burger',
      nameAr: 'برجر',
      descriptionEn: 'Tasty',
      descriptionAr: 'لذيذ',
      productType: ProductType.simple,
      price: 10,
      discountPercentage: 0,
      discountType: 'none',
      categoryId: 1,
      status: ProductStatus.active,
      isEditMode: false,
    );

    final tParamsUpdate = AddProductParams(
      nameEn: 'Burger',
      nameAr: 'برجر',
      descriptionEn: 'Tasty',
      descriptionAr: 'لذيذ',
      productType: ProductType.simple,
      price: 10,
      discountPercentage: 0,
      discountType: 'none',
      categoryId: 1,
      status: ProductStatus.active,
      isEditMode: true,
      productId: 1,
    );

    blocTest<AddFoodCubit, AddFoodState>(
      'emits [AddFoodSubmitting, AddFoodSuccess] and calls AddProductUseCase when isEditMode=false',
      build: () {
        when(() => mockAddProductUseCase(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.submitForm(tParamsAdd),
      expect: () => [
        AddFoodSubmitting(),
        AddFoodSuccess(),
      ],
      verify: (_) {
        verify(() => mockAddProductUseCase(tParamsAdd)).called(1);
        verifyNever(() => mockUpdateProductUseCase(any(), any()));
      },
    );

    blocTest<AddFoodCubit, AddFoodState>(
      'emits [AddFoodSubmitting, AddFoodSuccess] and calls UpdateProductUseCase when isEditMode=true',
      build: () {
        when(() => mockUpdateProductUseCase(any(), any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.submitForm(tParamsUpdate),
      expect: () => [
        AddFoodSubmitting(),
        AddFoodSuccess(),
      ],
      verify: (_) {
        verify(() => mockUpdateProductUseCase(1, tParamsUpdate)).called(1);
        verifyNever(() => mockAddProductUseCase(any()));
      },
    );

    blocTest<AddFoodCubit, AddFoodState>(
      'emits [AddFoodSubmitting, AddFoodValidationError] on ValidationFailure',
      build: () {
        when(() => mockAddProductUseCase(any()))
            .thenAnswer((_) async => const Left(ValidationFailure('Validation Error', errors: {'name': ['Required']})));
        return cubit;
      },
      act: (cubit) => cubit.submitForm(tParamsAdd),
      expect: () => [
        AddFoodSubmitting(),
        const AddFoodValidationError({'name': ['Required']}),
      ],
    );
  });
}
