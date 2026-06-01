import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.rating,
    required super.comment,
    required super.customerName,
    required super.createdAt,
    super.orderId,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      comment: json['comment']?.toString() ?? json['review']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ??
          json['user']?['name']?.toString() ??
          'Anonymous',
      createdAt: json['created_at']?.toString() ?? '',
      orderId: json['order_id'] is int
          ? json['order_id']
          : int.tryParse(json['order_id']?.toString() ?? ''),
    );
  }
}

class ReviewsSummaryModel extends ReviewsSummaryEntity {
  const ReviewsSummaryModel({
    required super.averageRating,
    required super.totalReviews,
    required super.reviews,
  });

  factory ReviewsSummaryModel.fromResponse(dynamic data) {
    if (data is List) {
      final reviews = data
          .whereType<Map<String, dynamic>>()
          .map(ReviewModel.fromJson)
          .toList();
      final avg = reviews.isEmpty
          ? 0.0
          : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
      return ReviewsSummaryModel(
        averageRating: avg,
        totalReviews: reviews.length,
        reviews: reviews,
      );
    }

    if (data is Map<String, dynamic>) {
      final reviewsJson = data['reviews'] ?? data['ratings'] ?? data['data'] ?? [];
      final reviews = (reviewsJson as List)
          .whereType<Map<String, dynamic>>()
          .map(ReviewModel.fromJson)
          .toList();
      return ReviewsSummaryModel(
        averageRating: (data['average_rating'] ?? data['avg_rating'] ?? 0) is num
            ? (data['average_rating'] ?? data['avg_rating']).toDouble()
            : double.tryParse(
                  (data['average_rating'] ?? data['avg_rating'])?.toString() ?? '0',
                ) ??
                0,
        totalReviews: data['total_reviews'] is int
            ? data['total_reviews']
            : int.tryParse(data['total_reviews']?.toString() ?? '${reviews.length}') ??
                reviews.length,
        reviews: reviews,
      );
    }

    return const ReviewsSummaryModel(
      averageRating: 0,
      totalReviews: 0,
      reviews: [],
    );
  }
}
