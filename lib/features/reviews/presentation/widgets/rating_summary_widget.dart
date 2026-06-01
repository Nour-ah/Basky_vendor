import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';

class RatingSummaryWidget extends StatelessWidget {
  const RatingSummaryWidget({
    super.key,
    required this.averageRating,
    required this.totalReviews,
  });

  final double averageRating;
  final int totalReviews;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.9),
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            averageRating.toStringAsFixed(1),
            style: AppTextStyle.fontWhite16Bold.copyWith(fontSize: 42),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < averageRating.round()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  LocaleKeys.totalReviewsCount.tr(
                    namedArgs: {'count': totalReviews.toString()},
                  ),
                  style: AppTextStyle.fontWhite14Regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
