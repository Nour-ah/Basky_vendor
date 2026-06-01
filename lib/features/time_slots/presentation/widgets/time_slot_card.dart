import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TimeSlotCard extends StatelessWidget {
  const TimeSlotCard({
    super.key,
    required this.dayLabel,
    required this.opensAt,
    required this.closesAt,
    this.onEdit,
  });

  final String dayLabel;
  final String opensAt;
  final String closesAt;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.schedule, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dayLabel, style: AppTextStyle.fontBlack14Bold),
                Text('$opensAt - $closesAt', style: AppTextStyle.fontGrey14Medium),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
