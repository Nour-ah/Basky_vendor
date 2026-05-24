import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';

class OrderCardWidget extends StatelessWidget {
  const OrderCardWidget({
    super.key,
    required this.orderCode,
    required this.date,
    required this.time,
    required this.deliveryType,
    required this.itemsCount,
    required this.onDetailsPressed,
  });

  final String orderCode;
  final String date;
  final String time;
  final String deliveryType;
  final int itemsCount;
  final VoidCallback onDetailsPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyLight.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onDetailsPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.receipt, size: 20, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '#$orderCode',
                          style: AppTextStyle.fontBlack16Bold,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.green.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        deliveryType,
                        style: AppTextStyle.fontGreen14Bold.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(height: 1, color: AppColors.greyLight),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 18, color: AppColors.grey),
                        const SizedBox(width: 6),
                        Text(
                          '$date $time',
                          style: AppTextStyle.fontGrey14Regular,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.restaurant, size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          LocaleKeys.itemsCount.tr(namedArgs: {'count': itemsCount.toString()}),
                          style: AppTextStyle.fontPrimary14Regular.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

