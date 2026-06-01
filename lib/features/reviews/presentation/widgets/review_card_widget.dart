import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/review_entity.dart';

class ReviewCardWidget extends StatelessWidget {
  const ReviewCardWidget({super.key, required this.review});

  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(review.customerName, style: AppTextStyle.fontBlack14Bold),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.comment, style: AppTextStyle.fontBlack14Regular),
          ],
          const SizedBox(height: 8),
          Text(review.createdAt, style: AppTextStyle.fontGrey12Regular),
        ],
      ),
    );
  }
}
