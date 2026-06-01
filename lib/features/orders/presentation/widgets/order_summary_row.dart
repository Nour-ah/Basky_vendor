import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OrderSummaryRow extends StatelessWidget {
  const OrderSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.isDiscount = false,
  });

  final String label;
  final String value;
  final bool isBold;
  final bool isDiscount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? AppTextStyle.fontBlack14Bold : AppTextStyle.fontGrey14Medium,
          ),
          Text(
            value,
            style: isDiscount
                ? AppTextStyle.fontBlack14Regular.copyWith(color: AppColors.promoRed)
                : (isBold ? AppTextStyle.fontBlack16Bold : AppTextStyle.fontBlack14Regular),
          ),
        ],
      ),
    );
  }
}
