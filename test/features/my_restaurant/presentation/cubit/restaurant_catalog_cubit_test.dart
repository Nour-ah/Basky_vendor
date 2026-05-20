import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/category_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_status.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_summary_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/delete_product_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/get_categories_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/get_products_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/presentation/cubit/restaurant_catalog_cubit.dart';
import 'package:spider_restaurant/features/my_restaurant/presentation/cubit/restaurant_catalog_state.dart';

class MockGetCategoriesUseCase extends GetCategoriesUseCase {
  MockGetCategoriesUseCase(super.repository);
  
  @override
  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return const Right([CategoryEntity(id: 1, name: 'Food')]);
  }
}

class MockGetProductsUseCase extends GetProductsUseCase {
  MockGetProductsUseCase(super.repository);
  
  @override
  Future<Either<Failure, List<ProductSummaryEntity>>> call({int? categoryId, String? searchQuery, int page = 1, int limit = 15}) async {
    return const Right([
      ProductSummaryEntity(
        id: 1, 
        name: 'Item', 
        description: 'Desc', 
        price: 10, 
        discountPrice: 10, 
        categoryId: 1, 
        categoryName: 'Food', 
        status: ProductStatus.active,
      )
    ]);
  }
}

class MockDeleteProductUseCase extends DeleteProductUseCase {
  MockDeleteProductUseCase(super.repository);
  bool shouldFail = false;

  @override
  Future<Either<Failure, void>> call(int productId) async {
    if (shouldFail) {
      return const Left(ServerFailure('Failed'));
    }
    return const Right(null);
  }
}

void main() {
  late RestaurantCatalogCubit cubit;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase(null as dynamic);
    mockGetProductsUseCase = MockGetProductsUseCase(null as dynamic);
    mockDeleteProductUseCase = MockDeleteProductUseCase(null as dynamic);
    
    cubit = RestaurantCatalogCubit(
      getCategoriesUseCase: mockGetCategoriesUseCase,
      getProductsUseCase: mockGetProductsUseCase,
      deleteProductUseCase: mockDeleteProductUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  blocTest<RestaurantCatalogCubit, RestaurantCatalogState>(
    'emits [CatalogLoading, CatalogLoaded] on successful initialization',
    build: () => cubit,
    act: (cubit) => cubit.initCatalog(),
    expect: () => [
      isA<CatalogLoading>(),
      isA<CatalogLoaded>(),
    ],
  );

  blocTest<RestaurantCatalogCubit, RestaurantCatalogState>(
    'optimistically deletes product and rolls back on failure',
    build: () {
      mockDeleteProductUseCase.shouldFail = true;
      return cubit;
    },
    seed: () => CatalogLoaded(
      categories: const [CategoryEntity(id: 1, name: 'Food')],
      products: const [
        ProductSummaryEntity(
          id: 1, name: 'Item', description: 'Desc', price: 10, discountPrice: 10, 
          categoryId: 1, categoryName: 'Food', status: ProductStatus.active,
        )
      ],
    ),
    act: (cubit) => cubit.deleteProduct(1),
    expect: () => [
      isA<CatalogEmpty>(), // Instantly becomes empty as it's the only item
      isA<CatalogDeleteError>(), // Error emitted
      isA<CatalogLoaded>(), // Rolled back to loaded state with 1 item
    ],
  );
}
