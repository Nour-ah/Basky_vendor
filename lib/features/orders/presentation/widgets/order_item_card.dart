import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/order_summary_entity.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({
    super.key,
    required this.order,
    this.onTap,
    this.onStatusChange,
  });

  final OrderSummaryEntity order;
  final VoidCallback? onTap;
  final void Function(OrderStatus newStatus)? onStatusChange;

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == OrderStatus.delivered;
    final statusColor = isDelivered ? AppColors.primary : AppColors.red;
    final statusBgColor = isDelivered
        ? AppColors.primary.withValues(alpha: 0.1)
        : AppColors.red.withValues(alpha: 0.1);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${LocaleKeys.orderCode.tr()}: ${order.orderCode}',
                style: AppTextStyle.fontBlack14Bold,
              ),
              GestureDetector(
                onTap: () {
                  if (order.status == OrderStatus.pending && onStatusChange != null) {
                    onStatusChange!(OrderStatus.processing);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    order.status.toApiString().tr(), // translation key matches api string
                    style: AppTextStyle.fontRed14Bold.copyWith(
                      color: statusColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time_outlined, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text(order.dateTime, style: AppTextStyle.fontGrey12Regular),
              _buildDivider(),
              Text(
                order.orderType,
                style: AppTextStyle.fontPrimary12Regular.copyWith(fontWeight: FontWeight.w600),
              ),
              _buildDivider(),
              Text(
                LocaleKeys.itemsCount.tr(namedArgs: {'count': order.itemCount.toString()}),
                style: AppTextStyle.fontPrimary12Regular.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('|', style: TextStyle(color: AppColors.border, fontSize: 12)),
    );
  }
}
