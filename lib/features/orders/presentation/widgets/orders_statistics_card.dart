import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/order_summary_model.dart';

class OrdersStatisticsCard extends StatelessWidget {
  const OrdersStatisticsCard({super.key, required this.summary});

  final OrderSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(AppStrings.today.tr(), summary.todayOrders),
          _buildStatItem(AppStrings.thisWeek.tr(), summary.thisWeekOrders),
          _buildStatItem(AppStrings.thisMonth.tr(), summary.thisMonthOrders),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, int count) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyle.fontWhite14Regular.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_basket_outlined,
              color: AppColors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(count.toString(), style: AppTextStyle.fontWhite16Bold),
          ],
        ),
      ],
    );
  }
}
