import 'package:equatable/equatable.dart';

abstract class ToggleStatusState extends Equatable {
  const ToggleStatusState();

  @override
  List<Object?> get props => [];
}

class ToggleStatusInitial extends ToggleStatusState {}

class ToggleStatusLoading extends ToggleStatusState {}

class ToggleStatusSuccess extends ToggleStatusState {
  final bool isOpen;

  const ToggleStatusSuccess(this.isOpen);

  @override
  List<Object?> get props => [isOpen];
}

class ToggleStatusError extends ToggleStatusState {
  final String message;

  const ToggleStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
