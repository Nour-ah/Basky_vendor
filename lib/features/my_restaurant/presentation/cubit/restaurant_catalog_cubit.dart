import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_summary_entity.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'restaurant_catalog_state.dart';

class RestaurantCatalogCubit extends Cubit<RestaurantCatalogState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  static const int _limit = 15;

  RestaurantCatalogCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
    required this.deleteProductUseCase,
  }) : super(CatalogInitial());

  Future<void> initCatalog() async {
    if (isClosed) return;
    emit(CatalogLoading());

    debugPrint('🔵 RestaurantCatalogCubit: Initializing catalog');

    // Fetch categories first
    final catResult = await getCategoriesUseCase();
    if (isClosed) return;

    List<CategoryEntity> categories = [];
    catResult.fold(
      (failure) => _emitFailure(failure),
      (cats) => categories = cats,
    );

    if (categories.isEmpty) return; // Error already emitted

    // Fetch initial products
    final prodResult = await getProductsUseCase(page: 1, limit: _limit);
    if (isClosed) return;

    prodResult.fold(
      (failure) => _emitFailure(failure),
      (products) {
        if (products.isEmpty) {
          emit(CatalogEmpty(categories: categories));
        } else {
          emit(CatalogLoaded(
            categories: categories,
            products: products,
            hasReachedMax: products.length < _limit,
          ));
        }
      },
    );
  }

  Future<void> filterProducts({int? categoryId, String? searchQuery}) async {
    if (isClosed || state is! CatalogLoaded && state is! CatalogEmpty) return;
    
    final currentCategories = _extractCategories();
    emit(CatalogLoading());

    debugPrint('🔵 RestaurantCatalogCubit: Filtering products (cat: $categoryId, search: $searchQuery)');

    final result = await getProductsUseCase(categoryId: categoryId, searchQuery: searchQuery, page: 1, limit: _limit);
    if (isClosed) return;

    result.fold(
      (failure) => _emitFailure(failure),
      (products) {
        if (products.isEmpty) {
          emit(CatalogEmpty(categories: currentCategories));
        } else {
          emit(CatalogLoaded(
            categories: currentCategories,
            products: products,
            selectedCategoryId: categoryId,
            searchQuery: searchQuery ?? '',
            currentPage: 1,
            hasReachedMax: products.length < _limit,
          ));
        }
      },
    );
  }

  Future<void> loadMoreProducts() async {
    if (isClosed || state is! CatalogLoaded) return;
    final currentState = state as CatalogLoaded;
    if (currentState.hasReachedMax) return;

    final nextPage = currentState.currentPage + 1;
    final result = await getProductsUseCase(
      categoryId: currentState.selectedCategoryId,
      searchQuery: currentState.searchQuery,
      page: nextPage,
      limit: _limit,
    );

    if (isClosed) return;

    result.fold(
      (failure) => debugPrint('❌ RestaurantCatalogCubit: Pagination failed - ${failure.message}'),
      (newProducts) {
        emit(currentState.copyWith(
          products: List.of(currentState.products)..addAll(newProducts),
          currentPage: nextPage,
          hasReachedMax: newProducts.length < _limit,
        ));
      },
    );
  }

  Future<void> deleteProduct(int productId) async {
    if (isClosed || state is! CatalogLoaded) return;
    final currentState = state as CatalogLoaded;

    // Optimistic UI Update: Remove item instantly
    final originalProducts = List<ProductSummaryEntity>.from(currentState.products);
    final updatedProducts = originalProducts.where((p) => p.id != productId).toList();

    if (updatedProducts.isEmpty) {
       emit(CatalogEmpty(categories: currentState.categories));
    } else {
       emit(currentState.copyWith(products: updatedProducts));
    }

    // API Call
    final result = await deleteProductUseCase(productId);
    if (isClosed) return;

    result.fold(
      (failure) {
        // Rollback
        emit(CatalogDeleteError(failure.message));
        emit(currentState.copyWith(products: originalProducts));
      },
      (_) => debugPrint('✅ RestaurantCatalogCubit: Product deleted successfully'),
    );
  }

  List<CategoryEntity> _extractCategories() {
    if (state is CatalogLoaded) return (state as CatalogLoaded).categories;
    if (state is CatalogEmpty) return (state as CatalogEmpty).categories;
    return [];
  }

  void _emitFailure(Failure failure) {
    if (failure is NetworkFailure) {
      emit(CatalogNetworkError(failure.message));
    } else if (failure is UnauthorizedFailure) {
      emit(CatalogUnauthorizedError(failure.message));
    } else {
      emit(CatalogGenericError(failure.message));
    }
  }
}
