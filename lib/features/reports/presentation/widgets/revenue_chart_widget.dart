import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../domain/entities/reports_summary_entity.dart';

class RevenueChartWidget extends StatelessWidget {
  const RevenueChartWidget({super.key, required this.points});

  final List<ReportChartPointEntity> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(LocaleKeys.noChartData.tr(), style: AppTextStyle.fontGrey14Medium),
      );
    }

    final maxValue = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: points.map((point) {
          final heightFactor = maxValue > 0 ? point.value / maxValue : 0.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: FractionallySizedBox(
                      heightFactor: heightFactor.clamp(0.05, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    point.label.length > 4 ? point.label.substring(0, 4) : point.label,
                    style: AppTextStyle.fontGrey12Regular,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
