import 'package:equatable/equatable.dart';
import '../../domain/entities/variant_entity.dart';

abstract class VariantsState extends Equatable {
  const VariantsState();
  @override
  List<Object?> get props => [];
}

class VariantsInitial extends VariantsState {}

class VariantsLoading extends VariantsState {}

class VariantsLoaded extends VariantsState {
  final List<VariantEntity> variants;
  const VariantsLoaded(this.variants);

  @override
  List<Object?> get props => [variants];
}

class VariantsEmpty extends VariantsState {}

class VariantsError extends VariantsState {
  final String message;
  const VariantsError(this.message);

  @override
  List<Object?> get props => [message];
}

class VariantsSubmitting extends VariantsState {}

class VariantsActionSuccess extends VariantsState {}
