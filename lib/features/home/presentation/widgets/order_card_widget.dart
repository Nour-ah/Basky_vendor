import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../orders/domain/entities/order_status.dart';

class OrderCardWidget extends StatelessWidget {
  const OrderCardWidget({
    super.key,
    required this.orderCode,
    required this.date,
    required this.time,
    required this.deliveryType,
    required this.itemsCount,
    this.totalAmount,
    this.status,
    required this.onDetailsPressed,
  });

  final String orderCode;
  final String date;
  final String time;
  final String deliveryType;
  final int itemsCount;
  final double? totalAmount;
  final OrderStatus? status;
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
                // ─── Row 1: Order code + Status + Delivery type ───
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
                    Expanded(
                      child: Text(
                        '#$orderCode',
                        style: AppTextStyle.fontBlack16Bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (status != null) _buildStatusBadge(status!),
                    const SizedBox(width: 8),
                    _buildDeliveryBadge(deliveryType),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.greyLight),
                const SizedBox(height: 16),

                // ─── Row 2: Date/Time + Items Count ───
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 18, color: AppColors.grey),
                        const SizedBox(width: 6),
                        Text(
                          date.isNotEmpty ? '$date $time' : '',
                          style: AppTextStyle.fontGrey14Regular,
                        ),
                      ],
                    ),
                    if (itemsCount > 0)
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

                // ─── Row 3: Total amount ───
                if (totalAmount != null && totalAmount! > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${LocaleKeys.total.tr()}: ',
                        style: AppTextStyle.fontGrey14Regular,
                      ),
                      Text(
                        '${totalAmount!.toStringAsFixed(2)} EGP',
                        style: AppTextStyle.fontBlack16Bold.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    final (Color bgColor, Color textColor) = _statusColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toApiString().tr(),
        style: AppTextStyle.fontRed14Bold.copyWith(
          color: textColor,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildDeliveryBadge(String deliveryType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.2)),
      ),
      child: Text(
        deliveryType,
        style: AppTextStyle.fontGreen14Bold.copyWith(fontSize: 11),
      ),
    );
  }

  (Color, Color) _statusColors(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return (AppColors.orange.withValues(alpha: 0.15), AppColors.orange);
      case OrderStatus.processing:
      case OrderStatus.readyForPickup:
      case OrderStatus.readyForDelivery:
        return (AppColors.blue.withValues(alpha: 0.15), AppColors.blue);
      case OrderStatus.shipped:
      case OrderStatus.outForDelivery:
        return (AppColors.purple.withValues(alpha: 0.15), AppColors.purple);
      case OrderStatus.delivered:
        return (AppColors.green.withValues(alpha: 0.15), AppColors.green);
      case OrderStatus.cancelled:
      case OrderStatus.returned:
      case OrderStatus.refunded:
        return (AppColors.red.withValues(alpha: 0.15), AppColors.red);
      case OrderStatus.unknown:
        return (AppColors.grey.withValues(alpha: 0.15), AppColors.grey);
    }
  }
}

