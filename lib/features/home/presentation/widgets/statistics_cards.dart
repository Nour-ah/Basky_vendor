import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
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
              numericValue: totalOrders.toDouble(),
              icon: Icons.receipt_long,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              title: LocaleKeys.yourEarnings.tr(),
              numericValue: totalEarnings,
              prefix: '\$',
              icon: Icons.account_balance_wallet,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.numericValue,
    required this.icon,
    this.prefix = '',
  });

  final String title;
  final double numericValue;
  final String prefix;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.8), width: 1.5),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.white.withValues(alpha: 0.9),
                AppColors.white.withValues(alpha: 0.4),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 15,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary.withValues(alpha: 0.8), size: 28),
              const SizedBox(height: 12),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: numericValue),
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Text(
                    '$prefix${value.toInt()}',
                    style: AppTextStyle.heading24Bold,
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppTextStyle.fontGrey12Regular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

