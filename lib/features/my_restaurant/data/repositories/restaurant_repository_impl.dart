import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/add_branch_params.dart';
import '../../domain/entities/add_product_params.dart';
import '../../domain/entities/branch_details_response_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/entities/product_details_entity.dart';
import '../../domain/entities/product_summary_entity.dart';
import '../../domain/entities/product_variant_entity.dart';
import '../../domain/entities/vendor_branch_entity.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, VendorBranchEntity?>> getPrimaryBranch() async {
    return _execute(() async {
      final branches = await remoteDataSource.getBranches();
      if (branches.isEmpty) return null;
      return branches.first;
    });
  }

  @override
  Future<Either<Failure, List<VendorBranchEntity>>> getBranches() async {
    return _execute(() => remoteDataSource.getBranches());
  }

  @override
  Future<Either<Failure, BranchDetailsResponseEntity>> getBranchDetails(int branchId, {int page = 1}) async {
    return _execute(() => remoteDataSource.getBranchDetails(branchId, page: page));
  }

  @override
  Future<Either<Failure, void>> addBranch(AddBranchParams params) async {
    return _execute(() => remoteDataSource.addBranch(params));
  }

  @override
  Future<Either<Failure, void>> updateBranch(int branchId, AddBranchParams params) async {
    return _execute(() => remoteDataSource.updateBranch(branchId, params));
  }

  @override
  Future<Either<Failure, void>> deleteBranch(int branchId) async {
    return _execute(() => remoteDataSource.deleteBranch(branchId));
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountries() async {
    return _execute(() => remoteDataSource.getCountries());
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    return _execute(() => remoteDataSource.getCategories());
  }

  @override
  Future<Either<Failure, List<ProductVariantEntity>>> getVariants() async {
    return _execute(() => remoteDataSource.getVariants());
  }

  @override
  Future<Either<Failure, List<ProductSummaryEntity>>> getProducts({
    int? categoryId,
    String? searchQuery,
    int page = 1,
    int limit = 15,
  }) async {
    return _execute(() => remoteDataSource.getProducts(
          categoryId: categoryId,
          searchQuery: searchQuery,
          page: page,
          limit: limit,
        ));
  }

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(int productId) async {
    return _execute(() => remoteDataSource.getProductDetails(productId));
  }

  @override
  Future<Either<Failure, void>> addProduct(AddProductParams params) async {
    return _execute(() => remoteDataSource.addProduct(params));
  }

  @override
  Future<Either<Failure, void>> updateProduct(int productId, AddProductParams params) async {
    return _execute(() => remoteDataSource.updateProduct(productId, params));
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int productId) async {
    return _execute(() => remoteDataSource.deleteProduct(productId));
  }

  @override
  Future<Either<Failure, void>> toggleProductActive(int productId) async {
    return _execute(() => remoteDataSource.toggleProductActive(productId));
  }

  @override
  Future<Either<Failure, bool>> toggleStatus() async {
    return _execute(() => remoteDataSource.toggleStatus());
  }

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
