import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionCardWidget extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionCardWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isDeposit = transaction.type.toLowerCase() == 'deposit';
    final Color statusColor = _getStatusColor(transaction.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isDeposit 
                ? AppColors.success.withValues(alpha: 0.1) 
                : AppColors.error.withValues(alpha: 0.1),
            child: Icon(
              isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isDeposit ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDeposit
                      ? LocaleKeys.wallet_deposit.tr()
                      : LocaleKeys.wallet_withdrawal.tr(namedArgs: {'type': transaction.type}),
                  style: AppTextStyle.fontBlack14Regular.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(transaction.createdAt, style: AppTextStyle.fontGrey12Regular),
                if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(transaction.notes!, style: AppTextStyle.fontGrey12Regular),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isDeposit ? '+' : '-'}${transaction.amount} ${LocaleKeys.currency.tr()}',
                style: AppTextStyle.fontBlack16Bold.copyWith(
                  color: isDeposit ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaction.status.toUpperCase(),
                  style: AppTextStyle.fontGrey12Regular.copyWith(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'failed':
        return AppColors.error;
      default:
        return Colors.orange;
    }
  }
}
