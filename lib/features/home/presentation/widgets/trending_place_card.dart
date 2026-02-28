import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TrendingPlaceCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String distance;
  final String price;
  final String rating;
  final int index;

  const TrendingPlaceCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.distance,
    required this.price,
    required this.rating,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: 120,
                width: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: AppColors.greyLight,
                  child: const Icon(Icons.image, color: AppColors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyle.fontBlack14Bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  distance,
                  style: AppTextStyle.fontGrey12Regular.copyWith(fontSize: 10),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.circle,
                    size: 4,
                    color: AppColors.textLight,
                  ),
                ),
                const Icon(
                  Icons.directions_car,
                  size: 12,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  price,
                  style: AppTextStyle.fontGrey12Regular.copyWith(fontSize: 10),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.circle,
                    size: 4,
                    color: AppColors.textLight,
                  ),
                ),
                const Icon(Icons.star, size: 12, color: AppColors.yellow),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: AppTextStyle.fontBlack12Bold.copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
