import 'package:equatable/equatable.dart';
import '../../domain/entities/order_details_entity.dart';


abstract class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object?> get props => [];
}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsLoaded extends OrderDetailsState {
  final OrderDetailsEntity order;

  const OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderDetailsUpdating extends OrderDetailsState {
  final OrderDetailsEntity order;

  const OrderDetailsUpdating(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderDetailsError extends OrderDetailsState {
  final String message;
  final bool isNetworkError;

  const OrderDetailsError(this.message, {this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}

class OrderDetailsStatusUpdated extends OrderDetailsState {
  final OrderDetailsEntity order;

  const OrderDetailsStatusUpdated(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderDetailsStatusError extends OrderDetailsState {
  final String message;
  final OrderDetailsEntity order;

  const OrderDetailsStatusError(this.message, this.order);

  @override
  List<Object?> get props => [message, order];
}
