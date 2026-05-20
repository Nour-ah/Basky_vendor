import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/translations/locale_keys.g.dart';

class StatisticsCards extends StatelessWidget {
  const StatisticsCards({
    super.key,
    required this.totalOrders,
    required this.totalEarnings,
  });

  final int totalOrders;
  final double totalEarnings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              title: LocaleKeys.totalOrders.tr(),
              value: totalOrders.toString(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              title: LocaleKeys.yourEarnings.tr(),
              value: '\$${totalEarnings.toInt()}', // Simplified for display
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyLight.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
