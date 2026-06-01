import 'package:equatable/equatable.dart';
import '../../domain/entities/vendor_branch_entity.dart';

abstract class BranchesState extends Equatable {
  const BranchesState();

  @override
  List<Object> get props => [];
}

class BranchesInitial extends BranchesState {}

class BranchesLoading extends BranchesState {}

class BranchesLoaded extends BranchesState {
  final List<VendorBranchEntity> branches;

  const BranchesLoaded({required this.branches});

  @override
  List<Object> get props => [branches];
}

class BranchesEmpty extends BranchesState {}

class BranchesError extends BranchesState {
  final String message;

  const BranchesError({required this.message});

  @override
  List<Object> get props => [message];
}
