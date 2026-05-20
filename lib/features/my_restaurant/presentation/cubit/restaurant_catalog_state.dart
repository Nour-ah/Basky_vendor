import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_summary_entity.dart';

abstract class RestaurantCatalogState extends Equatable {
  const RestaurantCatalogState();
  @override
  List<Object?> get props => [];
}

class CatalogInitial extends RestaurantCatalogState {}
class CatalogLoading extends RestaurantCatalogState {}

class CatalogLoaded extends RestaurantCatalogState {
  final List<CategoryEntity> categories;
  final List<ProductSummaryEntity> products;
  final int? selectedCategoryId;
  final String searchQuery;
  final int currentPage;
  final bool hasReachedMax;

  const CatalogLoaded({
    required this.categories,
    required this.products,
    this.selectedCategoryId,
    this.searchQuery = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  CatalogLoaded copyWith({
    List<CategoryEntity>? categories,
    List<ProductSummaryEntity>? products,
    int? selectedCategoryId,
    String? searchQuery,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return CatalogLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [categories, products, selectedCategoryId, searchQuery, currentPage, hasReachedMax];
}

class CatalogEmpty extends RestaurantCatalogState {
  final List<CategoryEntity> categories;
  const CatalogEmpty({required this.categories});
  @override
  List<Object?> get props => [categories];
}

abstract class CatalogError extends RestaurantCatalogState {
  final String message;
  const CatalogError(this.message);
  @override
  List<Object?> get props => [message];
}

class CatalogNetworkError extends CatalogError {
  const CatalogNetworkError(super.message);
}
class CatalogUnauthorizedError extends CatalogError {
  const CatalogUnauthorizedError(super.message);
}
class CatalogGenericError extends CatalogError {
  const CatalogGenericError(super.message);
}
class CatalogDeleteError extends CatalogError {
  const CatalogDeleteError(super.message);
}
