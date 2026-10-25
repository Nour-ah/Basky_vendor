import 'package:equatable/equatable.dart';

import '../../domain/entities/country_entity.dart';

abstract class AddBranchState extends Equatable {
  const AddBranchState();

  @override
  List<Object?> get props => [];
}

class AddBranchInitial extends AddBranchState {}

class AddBranchLoadingForm extends AddBranchState {}

class AddBranchFormReady extends AddBranchState {
  final List<CountryEntity> countries;

  const AddBranchFormReady(this.countries);

  @override
  List<Object?> get props => [countries];
}

class AddBranchSubmitting extends AddBranchState {
  final List<CountryEntity> countries;

  const AddBranchSubmitting(this.countries);

  @override
  List<Object?> get props => [countries];
}

class AddBranchSuccess extends AddBranchState {}

class AddBranchValidationError extends AddBranchState {
  final Map<String, List<String>> validationErrors;
  final List<CountryEntity> countries;

  const AddBranchValidationError(this.validationErrors, this.countries);

  @override
  List<Object?> get props => [validationErrors, countries];
}

class AddBranchError extends AddBranchState {
  final String message;
  final List<CountryEntity> countries;

  const AddBranchError(this.message, {this.countries = const []});

  @override
  List<Object?> get props => [message, countries];
}
