import 'package:equatable/equatable.dart';
import '../../domain/entities/review_entity.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final ReviewsSummaryEntity summary;

  const ReviewsLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class ReviewsEmpty extends ReviewsState {}

class ReviewsError extends ReviewsState {
  final String message;
  final bool isNetworkError;

  const ReviewsError(this.message, {this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}
