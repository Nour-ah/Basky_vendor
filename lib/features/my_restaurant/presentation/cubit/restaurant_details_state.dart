import 'package:equatable/equatable.dart';
import '../../domain/entities/product_summary_entity.dart';
import '../../domain/entities/vendor_branch_entity.dart';

abstract class RestaurantDetailsState extends Equatable {
  const RestaurantDetailsState();

  @override
  List<Object> get props => [];
}

class RestaurantDetailsInitial extends RestaurantDetailsState {}

class RestaurantDetailsLoading extends RestaurantDetailsState {}

class RestaurantDetailsLoaded extends RestaurantDetailsState {
  final VendorBranchEntity branch;
  final List<ProductSummaryEntity> products;

  const RestaurantDetailsLoaded({
    required this.branch,
    required this.products,
  });

  @override
  List<Object> get props => [branch, products];
}

class RestaurantDetailsEmpty extends RestaurantDetailsState {}

class RestaurantDetailsError extends RestaurantDetailsState {
  final String message;

  const RestaurantDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
