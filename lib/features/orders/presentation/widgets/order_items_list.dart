import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../domain/entities/order_item_entity.dart';

class OrderItemsList extends StatelessWidget {
  const OrderItemsList({super.key, required this.items});

  final List<OrderItemEntity> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.orderItems.tr(), style: AppTextStyle.fontBlack16Bold),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: AppTextStyle.fontBlack14Bold),
                      Text(
                        '${LocaleKeys.quantity.tr()}: ${item.quantity}',
                        style: AppTextStyle.fontGrey12Regular,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${item.price * item.quantity} ${LocaleKeys.currency.tr()}',
                  style: AppTextStyle.fontPrimary14Regular.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
