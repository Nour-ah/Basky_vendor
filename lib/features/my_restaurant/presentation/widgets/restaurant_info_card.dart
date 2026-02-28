import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/restaurant_details_model.dart';

class RestaurantInfoCard extends StatelessWidget {
  final RestaurantDetailsModel details;

  const RestaurantInfoCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: ClipOval(
                child: Image.network(details.logoUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(details.name, style: AppTextStyle.heading18Bold),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: details.isOpen
                              ? AppStrings.open.tr()
                              : AppStrings.closed.tr(),
                          style: AppTextStyle.fontGreen14Bold.copyWith(
                            fontSize: 12,
                            color: details.isOpen
                                ? AppColors.green
                                : AppColors.red,
                          ),
                        ),
                        TextSpan(
                          text: ' • ${details.address}',
                          style: AppTextStyle.fontGrey12Regular,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star, color: AppColors.yellow, size: 16),
            const SizedBox(width: 4),
            Text(
              details.rating.toStringAsFixed(1),
              style: AppTextStyle.fontGrey12Regular.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(' • ', style: AppTextStyle.fontGrey12Regular),
            const Icon(
              Icons.access_time_outlined,
              color: AppColors.grey,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(details.deliveryTime, style: AppTextStyle.fontGrey12Regular),
            Text(' • ', style: AppTextStyle.fontGrey12Regular),
            const Icon(
              Icons.pedal_bike_outlined,
              color: AppColors.grey,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(details.deliveryFee, style: AppTextStyle.fontGrey12Regular),
          ],
        ),
      ],
    );
  }
}
