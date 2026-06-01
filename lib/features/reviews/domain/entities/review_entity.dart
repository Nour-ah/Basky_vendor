import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final int id;
  final double rating;
  final String comment;
  final String customerName;
  final String createdAt;
  final int? orderId;

  const ReviewEntity({
    required this.id,
    required this.rating,
    required this.comment,
    required this.customerName,
    required this.createdAt,
    this.orderId,
  });

  @override
  List<Object?> get props => [id, rating, comment, customerName, createdAt, orderId];
}

class ReviewsSummaryEntity extends Equatable {
  final double averageRating;
  final int totalReviews;
  final List<ReviewEntity> reviews;

  const ReviewsSummaryEntity({
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
  });

  @override
  List<Object?> get props => [averageRating, totalReviews, reviews];
}
