import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OrderInfoCard extends StatelessWidget {
  const OrderInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.trailing,
  });

  final String title;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.fontGrey12Regular),
                const SizedBox(height: 6),
                Text(value, style: AppTextStyle.fontBlack14Regular),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
