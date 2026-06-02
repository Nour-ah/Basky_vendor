import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/add_product_params.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/branch_details_response_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/category_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_details_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_summary_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/repositories/restaurant_repository.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_status.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/delete_product_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/get_categories_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/usecases/get_products_usecase.dart';
import 'package:spider_restaurant/features/my_restaurant/presentation/cubit/restaurant_catalog_cubit.dart';
import 'package:spider_restaurant/features/my_restaurant/presentation/cubit/restaurant_catalog_state.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_variant_entity.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/vendor_branch_entity.dart';

class FakeRestaurantRepository implements RestaurantRepository {
  @override
  Future<Either<Failure, VendorBranchEntity?>> getPrimaryBranch() async =>
      const Right(null);

  @override
  Future<Either<Failure, List<VendorBranchEntity>>> getBranches() async =>
      const Right([]);

  @override
  Future<Either<Failure, BranchDetailsResponseEntity>> getBranchDetails(
    int branchId, {
    int page = 1,
  }) async =>
      const Right(
        BranchDetailsResponseEntity(
          branch: VendorBranchEntity(
            id: 0,
            name: '',
            address: '',
            isOpen: false,
            rating: 0,
          ),
          products: [],
        ),
      );

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async => const Right([]);

  @override
  Future<Either<Failure, List<ProductVariantEntity>>> getVariants() async =>
      const Right([]);
  
  @override
  Future<Either<Failure, List<ProductSummaryEntity>>> getProducts({
    int? categoryId,
    String? searchQuery,
    int page = 1,
    int limit = 15,
  }) async => const Right([]);

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(int productId) async => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> addProduct(AddProductParams params) async => const Right(null);
  
  @override
  Future<Either<Failure, void>> updateProduct(int productId, AddProductParams params) async => const Right(null);

  @override
  Future<Either<Failure, void>> deleteProduct(int productId) async => const Right(null);

  @override
  Future<Either<Failure, void>> toggleProductActive(int productId) async =>
      const Right(null);

  @override
  Future<Either<Failure, bool>> toggleStatus() async => const Right(true);
}

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
    final fakeRepo = FakeRestaurantRepository();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase(fakeRepo);
    mockGetProductsUseCase = MockGetProductsUseCase(fakeRepo);
    mockDeleteProductUseCase = MockDeleteProductUseCase(fakeRepo);
    
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
