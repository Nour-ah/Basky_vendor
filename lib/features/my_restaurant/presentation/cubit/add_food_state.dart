import 'package:equatable/equatable.dart';

abstract class AddFoodState extends Equatable {
  const AddFoodState();
  @override
  List<Object?> get props => [];
}

class AddFoodInitial extends AddFoodState {}

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
