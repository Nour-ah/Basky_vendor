import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/add_product_params.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_details_entity.dart';
import '../../domain/entities/product_summary_entity.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    return _execute(() => remoteDataSource.getCategories());
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
