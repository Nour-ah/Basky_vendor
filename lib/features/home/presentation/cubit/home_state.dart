import 'package:equatable/equatable.dart';
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

  const HomeLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
