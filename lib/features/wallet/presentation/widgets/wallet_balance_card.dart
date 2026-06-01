import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class WalletBalanceCard extends StatelessWidget {
  final String title;
  final double amount;
  final String currency;
  final Color color;

  const WalletBalanceCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle.fontGrey14Medium.copyWith(color: color)),
          const SizedBox(height: 8),
          Text('$amount $currency', style: AppTextStyle.fontBlack24Bold.copyWith(color: color)),
        ],
      ),
    );
  }
}
