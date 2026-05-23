import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../my_restaurant/domain/entities/vendor_branch_entity.dart';
import '../../domain/entities/home_stats_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeStatsEntity stats;
  final User user;
  final VendorBranchEntity? branch;

  const HomeLoaded({
    required this.stats,
    required this.user,
    this.branch,
  });

  @override
  List<Object?> get props => [stats, user, branch];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
