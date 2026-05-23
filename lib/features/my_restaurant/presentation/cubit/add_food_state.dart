import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';

abstract class AddFoodState extends Equatable {
  const AddFoodState();
  @override
  List<Object?> get props => [];
}

class AddFoodInitial extends AddFoodState {}

class AddFoodLoadingForm extends AddFoodState {}

class AddFoodFormReady extends AddFoodState {
  final List<CategoryEntity> categories;

  const AddFoodFormReady({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class AddFoodSubmitting extends AddFoodState {}

class AddFoodSuccess extends AddFoodState {}

class AddFoodValidationError extends AddFoodState {
  final Map<String, List<String>> validationErrors;
  const AddFoodValidationError(this.validationErrors);

  @override
  List<Object?> get props => [validationErrors];
}

class AddFoodError extends AddFoodState {
  final String message;
  const AddFoodError(this.message);

  @override
  List<Object?> get props => [message];
}
