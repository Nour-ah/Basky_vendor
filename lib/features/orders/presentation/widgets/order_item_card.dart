import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/order_card_model.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({super.key, required this.order});

  final OrderCardModel order;

  @override
  Widget build(BuildContext context) {
    // Determine colors based on status (Delivered vs Return/other)
    final isDelivered = order.isDelivered;
    final statusColor = isDelivered ? AppColors.red : AppColors.grey;
    final statusBgColor = isDelivered
        ? AppColors.red.withOpacity(0.1)
        : AppColors.greyLight;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Order Code and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppStrings.orderCode}: ${order.orderCode}',
                style: AppTextStyle.fontBlack14Bold,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  order.status,
                  style: AppTextStyle.fontRed14Bold.copyWith(
                    color: statusColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: Date, Type, Items Count
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(order.dateTime, style: AppTextStyle.fontGrey12Regular),
              _buildDivider(),
              Text(
                order.orderType,
                style: AppTextStyle.fontPrimary12Regular.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildDivider(),
              Text(
                '${order.itemCount} ${AppStrings.items}',
                style: AppTextStyle.fontPrimary12Regular.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('|', style: TextStyle(color: AppColors.border, fontSize: 12)),
    );
  }
}
